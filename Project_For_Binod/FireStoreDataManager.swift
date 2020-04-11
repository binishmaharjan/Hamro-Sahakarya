//
//  FireStoreDataManager.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/11/10.
//  Copyright © 2019 JEC. All rights reserved.
//

import Foundation
import FirebaseFirestore
import PromiseKit
import CodableFirebase

final class FireStoreDataManager: ServerDataManager {
    
    func saveUser(userSession: UserSession) -> Promise<UserSession> {
        
        return Promise<UserSession> { seal in
            do {
                let userSessionData = try FirestoreEncoder().encode(userSession) as [String: Any]
                // Extracting user profile from the session
                let userData = userSessionData["profile"] as? [String: Any]
                
                guard let userProfileData = userData else {
                    DispatchQueue.main.async {
                        seal.reject(HSError.dataEncodingError)
                    }
                    return
                }
                
                DispatchQueue.global(qos: .default).async {
                    let documentRefernce = Firestore.firestore()
                        .collection(DatabaseReference.MEMBERS_REF)
                        .document(userSession.profile.uid)
                    
                    documentRefernce.setData(userProfileData) { (error) in
                        if let error = error {
                            DispatchQueue.main.async {
                                seal.reject(error)
                            }
                            return
                        }
                        
                        DispatchQueue.main.async {
                            seal.fulfill(userSession)
                        }
                    }
                }
                
            } catch {
                DispatchQueue.main.async {
                    seal.reject(HSError.dataEncodingError)
                }
            }
            
        }
        
    }
    
    func readUser(uid: String) -> Promise<UserSession?> {
        return Promise<UserSession?> { seal in
            
            let reference = Firestore.firestore()
                .collection(DatabaseReference.MEMBERS_REF)
                .document(uid)
            
            DispatchQueue.global(qos: .default).async {
                reference.getDocument { (snapshot, error) in
                    
                    if let error = error {
                        DispatchQueue.main.async {
                            seal.reject(error)
                        }
                        return
                    }
                    
                    guard let snapshot = snapshot else {
                        DispatchQueue.main.async {
                            seal.reject(HSError.noSnapshotError)
                        }
                        return
                    }
                    
                    guard let data = snapshot.data() else {
                        DispatchQueue.main.async {
                            seal.reject(HSError.emptyDataError)
                        }
                        return
                    }
                    
                    do {
                        let userProfile = try FirebaseDecoder().decode(UserProfile.self, from: data)
                        let userSession = UserSession(profile: userProfile)
                        DispatchQueue.main.async {
                            seal.fulfill(userSession)
                        }
                    } catch {
                        DispatchQueue.main.async {
                            seal.reject(HSError.dataDecodingError)
                        }
                    }
                    
                }
            }
            
        }
    }
    
    func updateProfileUrl(userSession: UserSession, url: URL) -> Promise<String> {
        return Promise<String> { seal in
            let uid = userSession.profile.uid
            let urlString = url.absoluteString
            
            let updateData = [DatabaseReference.ICON_URL : urlString]
            let iconUrlRefrence = Firestore.firestore().collection(DatabaseReference.MEMBERS_REF).document(uid)
            
            DispatchQueue.global().async {
                iconUrlRefrence.updateData(updateData) { (error) in
                    
                    if let error = error {
                        DispatchQueue.main.async { seal.reject(error) }
                        return
                    }
                    
                    DispatchQueue.main.async { seal.fulfill(uid) }
                }
            }
        }
    }
    
    func updatePassword(userSession: UserSession, newPassowrd: String) -> Promise<String> {
        return Promise<String> { seal in
            let uid = userSession.profile.uid
            
            let updateData = [DatabaseReference.KEYWORD : newPassowrd]
            let passwordReference = Firestore.firestore().collection(DatabaseReference.MEMBERS_REF).document(uid)
            
            DispatchQueue.global().async {
                passwordReference.updateData(updateData) { (error) in
                    
                    if let error = error {
                        DispatchQueue.main.async { seal.reject(error) }
                        return
                    }
                    
                    DispatchQueue.main.async { seal.fulfill(newPassowrd) }
                }
            }
        }
    }
    
    func changeStatus(for user: UserProfile) -> Promise<Void> {
        return Promise<Void> { seal in
            let newStatus: Status = user.status == .admin ? .member : .admin
            let updateData = [DatabaseReference.STATUS: newStatus.rawValue]
            let statusReferene = Firestore.firestore().collection(DatabaseReference.MEMBERS_REF).document(user.uid)
            
            let completion: (Error?) -> Void = { error in
                if let error = error {
                    DispatchQueue.main.async { seal.reject(error) }
                    return
                }
                
                DispatchQueue.main.async { seal.fulfill(()) }
            }
            
            DispatchQueue.global().async {
                statusReferene.updateData(updateData, completion: completion)
            }
        }
    }
    
    func getAllMembers() -> Promise<[UserProfile]> {
        return Promise<[UserProfile]> { seal in
            let reference = Firestore.firestore().collection(DatabaseReference.MEMBERS_REF)
            
            DispatchQueue.global().async {
                reference.getDocuments { (snapshots, error) in
                    
                    if let error = error {
                        DispatchQueue.main.async { seal.reject(error) }
                        return
                    }
                    
                    guard let snapshots = snapshots else {
                        DispatchQueue.main.async { seal.reject(HSError.noSnapshotError) }
                        return
                    }
                    
                    var userProfiles = [UserProfile]()
                    
                    snapshots.documents.forEach { (snapshot) in
                        
                        let data  = snapshot.data()
                        
                        do {
                            let userProfile = try FirestoreDecoder().decode(UserProfile.self, from: data)
                            userProfiles.append(userProfile)
                        } catch {
                            DispatchQueue.main.async { seal.reject(error) }
                        }
                        
                    }
                    
                    DispatchQueue.main.async { seal.fulfill(userProfiles) }
                }
            }
            
        }
    }
    
    func addMonthlyFee(for user: UserProfile, amount: Int) -> Promise<Void> {
        return Promise<Void> { seal in
            let reference = Firestore.firestore().collection(DatabaseReference.MEMBERS_REF).document(user.uid)
            let newAmount = user.balance + amount
            let updatedData = [DatabaseReference.BALANCE: newAmount]
            
            DispatchQueue.main.async {
                
                let completion: (Error?) -> Void = { error in
                    if let error = error {
                        DispatchQueue.main.async { seal.reject(error) }
                        return
                    }
                    
                    DispatchQueue.main.async { seal.fulfill(()) }
                }
                
                reference.updateData(updatedData, completion: completion)
            }
            
        }
    }
    
    func updateExtraAndExpenses(groupDetail: GroupDetail, extra: Int, expenses: Int) -> Promise<Void> {
        return Promise<Void> { seal in
            let reference = Firestore.firestore().collection(DatabaseReference.HAMRO_SAHAKARYA_REF).document(DatabaseReference.DETAIL_REF)
            let newExtra = groupDetail.extra + extra
            let newExpenses = groupDetail.expenses + expenses
            
            let updatedData = [
                DatabaseReference.EXTRA: newExtra,
                DatabaseReference.EXPENSES: newExpenses
            ]
            
            DispatchQueue.main.async {
                
                let completion: (Error?) -> Void = { error in
                    if let error = error {
                        DispatchQueue.main.async { seal.reject(error) }
                        return
                    }
                    
                    DispatchQueue.main.async { seal.fulfill(()) }
                }
                
                reference.updateData(updatedData, completion: completion)
            }
        }
    }
    
    func getExtraAndExpenses() -> Promise<GroupDetail> {
        return Promise<GroupDetail> { seal in
            let reference = Firestore.firestore().collection(DatabaseReference.HAMRO_SAHAKARYA_REF).document(DatabaseReference.DETAIL_REF)
            
            DispatchQueue.global().async {
                reference.getDocument { (snapshot, error) in
                    
                    if let error = error {
                        DispatchQueue.main.async { seal.reject(error) }
                        return
                    }
                    
                    guard let snapshot = snapshot else {
                        DispatchQueue.main.async { seal.reject(HSError.noSnapshotError) }
                        return
                    }
                    
                    guard let data  = snapshot.data() else {
                        DispatchQueue.main.async { seal.reject(HSError.emptyDataError) }
                        return
                    }
                    
                    do {
                        let groupDetail = try FirestoreDecoder().decode(GroupDetail.self, from: data)
                        DispatchQueue.main.async { seal.fulfill(groupDetail) }
                    } catch {
                        DispatchQueue.main.async { seal.reject(error) }
                    }
                    
                }
            }
        }
    }
    
    func loanMember(user: UserProfile, amount: Int) -> Promise<Void> {
        return Promise<Void> { seal in
            let reference = Firestore.firestore().collection(DatabaseReference.MEMBERS_REF).document(user.uid)
            let newAmount = user.loanTaken + amount
            let updatedData = [DatabaseReference.LOAN_TAKEN: newAmount]
            
            DispatchQueue.main.async {
                
                let completion: (Error?) -> Void = { error in
                    if let error = error {
                        DispatchQueue.main.async { seal.reject(error) }
                        return
                    }
                    
                    DispatchQueue.main.async { seal.fulfill(()) }
                }
                
                reference.updateData(updatedData, completion: completion)
            }
            
        }
    }
    
}
