//
//  FirebaseLogRemoteApi.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/01/19.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation
import PromiseKit
import FirebaseFirestore
import CodableFirebase
import FirebaseAuth

final class FireBaseLogRemoteApi: LogRemoteApi {
    
    private var lastSnapshot: QueryDocumentSnapshot?
    
    func getLogs() -> Promise<[GroupLog]> {
        return Promise<[GroupLog]> { seal in
            
            let reference = Firestore.firestore()
                .collection(DatabaseReference.LOGS_REF)
                .limit(to: 20)
                .order(by: DatabaseReference.DATE_CREATED,descending: true)
            
            DispatchQueue.global(qos: .default).async {
                reference.getDocuments { (snapshots, error) in
                    
                    if let error = error {
                        DispatchQueue.main.async { seal.reject(error) }
                        return
                    }
                    
                    guard let snapshots = snapshots else {
                        DispatchQueue.main.async { seal.reject(HSError.noSnapshotError) }
                        return
                    }
                    
                    if let lastSnapshot = snapshots.documents.last {
                        self.lastSnapshot = lastSnapshot
                    }
                    
                    var logs: [GroupLog] = [GroupLog]()
                    snapshots.documents.forEach { (snapshot) in
                        
                        let data  = snapshot.data()
                        
                        do {
                            let log = try FirestoreDecoder().decode(GroupLog.self, from: data)
                            logs.append(log)
                        } catch {
                            DispatchQueue.main.async { seal.reject(error) }
                        }
                        
                    }
                    
                    DispatchQueue.main.async { seal.fulfill(logs) }
                    
                }
            }
            
        }
    }
    
    func fetchLogsFromLastSnapshot() -> Promise<[GroupLog]> {
        
        return Promise<[GroupLog]> { [weak self] seal in
            
            guard let lastSnapshot = self?.lastSnapshot else {
                seal.reject(HSError.noSnapshotError)
                return
            }
            
            let reference = Firestore.firestore()
                .collection(DatabaseReference.LOGS_REF)
                .order(by: DatabaseReference.DATE_CREATED, descending: true)
                .limit(to: 20)
                .start(afterDocument: lastSnapshot)
            
            DispatchQueue.global(qos: .default).async {
                reference.getDocuments { (snapshots, error) in
                    
                    if let error = error {
                        DispatchQueue.main.async { seal.reject(error) }
                        return
                    }
                    
                    guard let snapshots = snapshots else {
                        DispatchQueue.main.async { seal.reject(HSError.noSnapshotError) }
                        return
                    }
                    
                    if let lastSnapshot = snapshots.documents.last {
                        self?.lastSnapshot = lastSnapshot
                    }
                    
                    var logs: [GroupLog] = [GroupLog]()
                    snapshots.documents.forEach { (snapshot) in
                        
                        let data  = snapshot.data()
                        
                        do {
                            let log = try FirestoreDecoder().decode(GroupLog.self, from: data)
                            logs.append(log)
                        } catch {
                            DispatchQueue.main.async { seal.reject(error) }
                        }
                        
                    }
                    
                    DispatchQueue.main.async { seal.fulfill(logs) }
                    
                }
            }
        }
    }
    
    
    func addJoinedLog(userSession: UserSession) -> Promise<UserSession> {
        return Promise<UserSession> { seal in
            let logCreator = userSession.profile.value.username
            let logTarget = userSession.profile.value.username
            let amount = userSession.profile.value.balance
            let log = generateLog(logType: .joined, logCreator: logCreator, logTarget: logTarget, amount: amount, reason: "")
            
            let logRef = Firestore.firestore().collection(DatabaseReference.LOGS_REF).document(log.logId)
            
            
            DispatchQueue.global().async {
                do {
                    let data = try FirestoreEncoder().encode(log) as [String:Any]
                    
                    let completion: (Error?) -> Void = { error in
                        guard let error = error else { return }
                        DispatchQueue.main.async { seal.reject(error)}
                    }
                    
                    logRef.setData(data, completion: completion)
                    
                    DispatchQueue.main.async { seal.fulfill(userSession) }
                    
                } catch {
                    DispatchQueue.main.async { seal.reject(error) }
                }
            }
            
        }
    }
    
    func addMonthlyFeeLog(admin: UserProfile, userProfile: UserProfile, amount: Int) -> Promise<Void> {
        return Promise<Void> { seal in
            
            let logCreator = admin.username
            let logTarget = userProfile.username
            let amount = amount
            let log = generateLog(logType: .monthlyFee, logCreator: logCreator, logTarget: logTarget, amount: amount, reason: "")
            
            let logRef = Firestore.firestore().collection(DatabaseReference.LOGS_REF).document(log.logId)
            
            DispatchQueue.global().async {
                do {
                    let data = try FirestoreEncoder().encode(log) as [String:Any]
                    
                    let completion: (Error?) -> Void = { error in
                        guard let error = error else { return }
                        DispatchQueue.main.async { seal.reject(error)}
                    }
                    
                    logRef.setData(data, completion: completion)
                    
                    DispatchQueue.main.async { seal.fulfill(()) }
                    
                } catch {
                    DispatchQueue.main.async { seal.reject(error) }
                }
            }
        }
    }
    
    func addExtraOrExpensesLog(type: ExtraOrExpenses, admin: UserProfile, amount: Int, reason: String) -> Promise<Void> {
        return Promise<Void> { seal in
            
            let logCreator = admin.username
            let logTarget = ""
            let amount = amount
            let reason = reason
            
            let logType: GroupLogType
            if case .extra = type {
                logType = GroupLogType.extra
            } else {
                logType = GroupLogType.expenses
            }
            
            let log  = generateLog(logType: logType, logCreator: logCreator, logTarget: logTarget, amount: amount, reason: reason)
            let logRef = Firestore.firestore().collection(DatabaseReference.LOGS_REF).document(log.logId)
            
            DispatchQueue.global().async {
                do {
                    let data = try FirestoreEncoder().encode(log) as [String:Any]
                    
                    let completion: (Error?) -> Void = { error in
                        guard let error = error else { return }
                        DispatchQueue.main.async { seal.reject(error)}
                    }
                    
                    logRef.setData(data, completion: completion)
                    
                    DispatchQueue.main.async { seal.fulfill(()) }
                    
                } catch {
                    DispatchQueue.main.async { seal.reject(error) }
                }
            }
        }
    }
    
    func addAmountOrDeductAmountLog(type: AddOrDeduct ,admin: UserProfile, member: UserProfile, amount: Int) -> Promise<Void> {
        return Promise<Void> { seal in
            
            let logCreator = admin.username
            let logTarget = ""
            let amount = amount
            let reason = ""
            
            let logType: GroupLogType
            if case .add = type {
                logType = GroupLogType.addAmount
            } else {
                logType = GroupLogType.deductAmount
            }
            
            let log  = generateLog(logType: logType, logCreator: logCreator, logTarget: logTarget, amount: amount, reason: reason)
            let logRef = Firestore.firestore().collection(DatabaseReference.LOGS_REF).document(log.logId)
            
            DispatchQueue.global().async {
                do {
                    let data = try FirestoreEncoder().encode(log) as [String:Any]
                    
                    let completion: (Error?) -> Void = { error in
                        guard let error = error else { return }
                        DispatchQueue.main.async { seal.reject(error)}
                    }
                    
                    logRef.setData(data, completion: completion)
                    
                    DispatchQueue.main.async { seal.fulfill(()) }
                    
                } catch {
                    DispatchQueue.main.async { seal.reject(error) }
                }
            }
        }
    }
    
    func addLoanMemberLog(admin: UserProfile, member: UserProfile, amount: Int) -> Promise<Void> {
        return Promise<Void> { seal in
            let logCreator = admin.username
            let logTarget = member.username
            let amount = amount
            let log = generateLog(logType: .loanGiven, logCreator: logCreator, logTarget: logTarget, amount: amount, reason: "")
            
            let logRef = Firestore.firestore().collection(DatabaseReference.LOGS_REF).document(log.logId)
            
            
            DispatchQueue.global().async {
                do {
                    let data = try FirestoreEncoder().encode(log) as [String:Any]
                    
                    let completion: (Error?) -> Void = { error in
                        guard let error = error else { return }
                        DispatchQueue.main.async { seal.reject(error)}
                    }
                    
                    logRef.setData(data, completion: completion)
                    
                    DispatchQueue.main.async { seal.fulfill(()) }
                    
                } catch {
                    DispatchQueue.main.async { seal.reject(error) }
                }
            }
            
        }
    }
    
    func addLoanReturnedLog(admin: UserProfile, member: UserProfile, amount: Int) -> Promise<Void> {
        return Promise<Void> { seal in
            let logCreator = admin.username
            let logTarget = member.username
            let amount = amount
            
            let log = generateLog(logType: .loanReturned, logCreator: logCreator, logTarget: logTarget, amount: amount, reason: "")
            let logRef = Firestore.firestore().collection(DatabaseReference.LOGS_REF).document(log.logId)
            
            
            DispatchQueue.global().async {
                do {
                    let data = try FirestoreEncoder().encode(log) as [String: Any]
                    
                    let completion: (Error?) -> Void = { error in
                        guard let error = error else { return }
                        DispatchQueue.main.async { seal.reject(error) }
                    }
                    
                    logRef.setData(data, completion: completion)
                    
                    DispatchQueue.main.async { seal.fulfill(()) }
                } catch {
                    DispatchQueue.main.async { seal.reject(error) }
                }
            }
        }
    }
    
    func addRemoveMemberLog(admin: UserProfile, member: UserProfile) -> Promise<Void> {
        return Promise<Void> { seal in
            let logCreator = admin.username
            let logTarget = member.username
            let amount = member.balance
            
            let log = generateLog(logType: .removed, logCreator: logCreator, logTarget: logTarget, amount: amount, reason: "")
            let logRef = Firestore.firestore().collection(DatabaseReference.LOGS_REF).document(log.logId)
            
            DispatchQueue.global().async {
                do {
                    let data = try FirestoreEncoder().encode(log) as [String: Any]
                    
                    let completion: (Error?) -> Void = { error in
                        guard let error = error else { return }
                        DispatchQueue.main.async { seal.reject(error) }
                    }
                    
                    logRef.setData(data, completion: completion)
                    
                    DispatchQueue.main.async { seal.fulfill(())}
                    
                } catch {
                    DispatchQueue.main.async { seal.reject(error) }
                }
            }
        }
    }
    
}

extension FireBaseLogRemoteApi {
    
    private func generateRandomID(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0...length-1).map{ _ in letters.randomElement()! })
    }
    
    private func generateLog(logType: GroupLogType, logCreator: String, logTarget: String, amount: Int, reason: String) -> GroupLog {
        let logID = generateRandomID(length: 20)
        let log = GroupLog(logId: logID,
                           dateCreated: Date().toString,
                           logType: logType,
                           logCreator: logCreator,
                           logTarget: logTarget, amount: amount,
                           reason: reason)
        
        return log
    }
}
