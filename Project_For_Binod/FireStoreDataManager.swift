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

class FireStoreDataManager: ServerDataManager {
  
  func saveUser(userProfile: UserProfile) -> Promise<UserProfile> {
    
    return Promise<UserProfile> { seal in
      do {
        let userProfileData = try FirestoreEncoder().encode(userProfile) as [String: Any]
        
       
        DispatchQueue.global(qos: .default).async {
          let documentRefernce = Firestore.firestore().collection(DatabaseReference.MEMBERS_REF).document(userProfile.uid)
          
          documentRefernce.setData(userProfileData) { (error) in
            if let error = error {
              DispatchQueue.main.async { seal.reject(error) }
              return
            }
            
            DispatchQueue.main.async { seal.fulfill(userProfile) }
          }
        }
        
      } catch {
        DispatchQueue.main.async {  seal.reject(HSError.dataEncodingError) }
      }
      
    }
    
  }
  
  func readUser(uid: String) -> Promise<UserProfile?> {
    return Promise<UserProfile?> { seal in
      
      let reference = Firestore.firestore().collection(DatabaseReference.MEMBERS_REF).document(uid)
      
      DispatchQueue.global(qos: .default).async {
        reference.getDocument { (snapshot, error) in
          
          if let error = error {
            DispatchQueue.main.async { seal.reject(error) }
            return
          }
          
          guard let snapshot = snapshot else {
            DispatchQueue.main.async { seal.reject(HSError.noSnapshotError) }
            return
          }
          
          guard let data = snapshot.data() else {
            DispatchQueue.main.async {  seal.reject(HSError.emptyDataError) }
            return
          }
          
          do {
            let userProfile = try FirebaseDecoder().decode(UserProfile.self, from: data)
            DispatchQueue.main.async { seal.fulfill(userProfile) }
          } catch {
            DispatchQueue.main.async { seal.reject(HSError.dataDecodingError) }
          }
          
        }
      }
      
    }
  }
  
}
