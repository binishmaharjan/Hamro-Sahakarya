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
  
}
