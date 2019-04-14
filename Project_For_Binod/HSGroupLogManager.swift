//
//  HSGroupLogManager.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/03/30.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import CodableFirebase
import FirebaseFirestore

protocol HSGroupLogManager{
  func writeLog(logOwner:String,logCreator:String,amount:Int,
                logType:String,reason:String,dateCreated:String,completion:((Error?)->())?)
  func readUserLog(uid:String,completion:(([HSLog]?,QueryDocumentSnapshot?,Bool?,Error?)->())?)
  func readUserLogFromLastSnapshot(uid:String,lastSnapshot:QueryDocumentSnapshot,completion:(([HSLog]?,QueryDocumentSnapshot?,Bool?,Error?)->())?)
  
  func readAllLog(completion:(([HSLog]?,QueryDocumentSnapshot?,Bool?,Error?)->())?)
  func readAllLogFromLastSnapshot(lastSnapshot:QueryDocumentSnapshot,completion:(([HSLog]?,QueryDocumentSnapshot?,Bool?,Error?)->())?)
}

extension HSGroupLogManager{
  func writeLog(logOwner:String,logCreator:String,amount:Int,
                logType:String,reason:String,dateCreated:String,completion:((Error?)->())?){
    
    let logId = randomID(length: 20)
    let log = HSLog.init(lodId: logId, logOwner: logOwner, logCreator: logCreator, amount: amount, logType: logType, reason:reason, dateCreated: dateCreated)
    
    do{
      let logRef = Firestore.firestore().collection(DatabaseReference.LOGS_REF).document(logId)
      let data = try FirestoreEncoder().encode(log) as [String:Any]
      
      DispatchQueue.global().async {
        logRef.setData(data, completion: { (error) in
          if let error = error{
            completion?(error)
            return
          }
          completion?(nil)
        })
      }
    }catch{
      completion?(error)
    }
  }
  
  func readUserLog(uid:String,completion:(([HSLog]?,QueryDocumentSnapshot?,Bool?,Error?)->())?){
    let ref = Firestore.firestore()
      .collection(DatabaseReference.LOGS_REF)
      .whereField(DatabaseReference.LOG_OWNER, isEqualTo: uid)
      .limit(to: 10)
      .order(by: DatabaseReference.DATE_CREATED, descending: true)
    
    DispatchQueue.global(qos: .default).async {
      ref.getDocuments(completion: { (snapshot, error) in
        if let error = error{
          completion?(nil,nil,nil,error)
          return
        }
        
        guard let snapshot = snapshot else{
          completion?(nil,nil,nil,NO_SNAPSHOT_ERROR)
          return
        }
        
        guard let lastSnapshot = snapshot.documents.last else {
          completion?(nil,nil,true,nil)
          return
        }
        
        var logs:[HSLog] = [HSLog]()
        snapshot.documents.forEach({ (document) in
          let data = document.data()
          do{
            let log = try FirestoreDecoder().decode(HSLog.self, from: data)
            logs.append(log)
          }catch{
            completion?(nil,nil,nil,error)
          }
        })
        
        completion?(logs,lastSnapshot,false,nil)
      })
    }
  }
  
  func readUserLogFromLastSnapshot(uid:String,lastSnapshot:QueryDocumentSnapshot,completion:(([HSLog]?,QueryDocumentSnapshot?,Bool?,Error?)->())?){
    let ref = Firestore.firestore()
              .collection(DatabaseReference.LOGS_REF)
              .whereField(DatabaseReference.LOG_OWNER, isEqualTo: uid)
              .order(by: DatabaseReference.DATE_CREATED, descending: true)
              .limit(to: 10)
              .start(afterDocument: lastSnapshot)
    
    DispatchQueue.global(qos: .default).async {
      ref.getDocuments(completion: { (snapshot, error) in
        if let error = error{
          completion?(nil,nil,nil,error)
          return
        }
        
        guard let snapshot = snapshot else{
          completion?(nil,nil,nil,NO_SNAPSHOT_ERROR)
          return
        }
        
        guard let lastSnapshot = snapshot.documents.last else {
          completion?(nil,nil,true,nil)
          return
        }
        
        var logs:[HSLog] = [HSLog]()
        snapshot.documents.forEach({ (document) in
          let data = document.data()
          do{
            let log = try FirestoreDecoder().decode(HSLog.self, from: data)
            logs.append(log)
          }catch{
            completion?(nil,nil,nil,error)
          }
        })
        
        completion?(logs,lastSnapshot,false,nil)
      })
    }
  }
  
  func readAllLog(completion:(([HSLog]?,QueryDocumentSnapshot?,Bool?,Error?)->())?){
    let ref = Firestore.firestore()
      .collection(DatabaseReference.LOGS_REF)
      .limit(to: 10)
      .order(by: DatabaseReference.DATE_CREATED, descending: true)
    
    DispatchQueue.global(qos: .default).async {
      ref.getDocuments(completion: { (snapshot, error) in
        if let error = error{
          completion?(nil,nil,nil,error)
          return
        }
        
        guard let snapshot = snapshot else{
          completion?(nil,nil,nil,NO_SNAPSHOT_ERROR)
          return
        }
        
        guard let lastSnapshot = snapshot.documents.last else {
          completion?(nil,nil,true,nil)
          return
        }
        
        var logs:[HSLog] = [HSLog]()
        snapshot.documents.forEach({ (document) in
          let data = document.data()
          do{
            let log = try FirestoreDecoder().decode(HSLog.self, from: data)
            logs.append(log)
          }catch{
            completion?(nil,nil,nil,error)
          }
        })
        
        completion?(logs,lastSnapshot,false,nil)
      })
    }
  }
  
  func readAllLogFromLastSnapshot(lastSnapshot:QueryDocumentSnapshot,completion:(([HSLog]?,QueryDocumentSnapshot?,Bool?,Error?)->())?){
    let ref = Firestore.firestore()
      .collection(DatabaseReference.LOGS_REF)
      .order(by: DatabaseReference.DATE_CREATED, descending: true)
      .limit(to: 10)
      .start(afterDocument: lastSnapshot)
    
    DispatchQueue.global(qos: .default).async {
      ref.getDocuments(completion: { (snapshot, error) in
        if let error = error{
          completion?(nil,nil,nil,error)
          return
        }
        
        guard let snapshot = snapshot else{
          completion?(nil,nil,nil,NO_SNAPSHOT_ERROR)
          return
        }
        
        guard let lastSnapshot = snapshot.documents.last else {
          completion?(nil,nil,true,nil)
          return
        }
        
        var logs:[HSLog] = [HSLog]()
        snapshot.documents.forEach({ (document) in
          let data = document.data()
          do{
            let log = try FirestoreDecoder().decode(HSLog.self, from: data)
            logs.append(log)
          }catch{
            completion?(nil,nil,nil,error)
          }
        })
        
        completion?(logs,lastSnapshot,false,nil)
      })
    }
  }
}
