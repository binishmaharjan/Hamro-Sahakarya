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
}
