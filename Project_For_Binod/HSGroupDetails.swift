//
//  HSGroupDetails.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/04/11.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import FirebaseFirestore
import CodableFirebase

protocol HSGroupDetail{
  func readGroupDetail(completion:((HSGroup?,Error?)->())?)
  func addToTotalBalanceAndMember(amount:Int,completion:((Error?)->())?)
}

extension HSGroupDetail{
  func readGroupDetail(completion:((HSGroup?,Error?)->())?){
    let ref = Firestore.firestore().collection(DatabaseReference.HAMRO_SAHAKARYA_REF).document(DatabaseReference.DETAIL_REF)
    DispatchQueue.global(qos: .default).async {
      ref.getDocument(completion: { (snapshot, error) in
        if let error = error{
          completion?(nil,error)
          return
        }
        
        guard let snapshot = snapshot else {
          completion?(nil,NO_SNAPSHOT_ERROR)
          return
        }
        
        guard let data = snapshot.data() else{
          completion?(nil,error)
          return
        }
        
        do{
          let group = try FirestoreDecoder().decode(HSGroup.self, from: data)
          completion?(group,nil)
        }catch{
          completion?(nil,error)
        }
        
      })
    }
  }
  
  func addToTotalBalanceAndMember(amount:Int,completion:((Error?)->())?){
    let ref = Firestore.firestore().collection(DatabaseReference.HAMRO_SAHAKARYA_REF).document(DatabaseReference.DETAIL_REF)
    DispatchQueue.global(qos: .default).async {
      self.readGroupDetail(completion: { (group, error) in
        if let error = error{
          completion?(error)
          return
        }
        
        guard let group = group,
              let totalBalance = group.totalBalance,
              let members = group.members
          else{
          completion?(EMPTY_DATA_ERROR)
          return
        }
        let data = [
          DatabaseReference.TOTAL_BALANCE : totalBalance + amount,
          DatabaseReference.MEMBERS_REF : members + 1
        ]
        
        ref.updateData(data, completion: { (error) in
          if let error = error{
            completion?(error)
            return
          }
          completion?(nil)
        })
      })
    }
  }
}
