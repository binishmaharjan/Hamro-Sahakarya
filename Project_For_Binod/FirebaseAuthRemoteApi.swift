//
//  FirebaseAuthRemoteApi.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/11/09.
//  Copyright © 2019 JEC. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import CodableFirebase
import PromiseKit

final class FirebaseAuthRemoteApi: AuthRemoteApi {
  
  func signIn(email: String, password: String) -> Promise<String> {
    
    return Promise<String> { seal in

      DispatchQueue.global(qos: .default).async {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
          
          if let error = error {
            DispatchQueue.main.async {
              seal.reject(error)
            }
            return
          }

          guard let userData = result?.user else {
            DispatchQueue.main.async {
              seal.reject(HSError.emptyDataError)
            }
            return
          }
          
          DispatchQueue.main.async {
            seal.fulfill(userData.uid)
          }
          
          
          // Login Successful > Get User Data From The Database
//          self.serverDataManager.readUser(uid: userData.uid).done { (userProfile) in
//            DispatchQueue.main.async { seal.fulfill(userProfile!) }
//          }.catch { (error) in
//            DispatchQueue.main.async { seal.reject(error) }
//          }

        }
      }

    }

  }
  
  func signUp(newAccount: NewAccount) -> Promise<String> {
    return Promise<String> { seal in
      
      DispatchQueue.global(qos: .default).async {
        Auth.auth().createUser(withEmail: newAccount.email, password: newAccount.keyword) { (result, error) in
          
          if let error = error {
            DispatchQueue.main.async { seal.reject(error) }
            return
          }
          
          guard let userData = result?.user else {
            DispatchQueue.main.async { seal.reject(HSError.emptyDataError) }
            return
          }
          
          let changeRequest = userData.createProfileChangeRequest()
          changeRequest.displayName = newAccount.username
          changeRequest.commitChanges { (error) in
            if let error = error {
              DispatchQueue.main.async { seal.reject(error) }
              return
            }
          }
          
          
          DispatchQueue.main.async { seal.fulfill(userData.uid) }
        }
      }
      
    }
  }
  
  func signOut(userSession: UserSession) -> Promise<UserSession> {
    return Promise<UserSession> { seal in
      
      DispatchQueue.global(qos: .default).async {
        do {
          try Auth.auth().signOut()
          seal.fulfill(userSession)
        } catch {
          seal.reject(error)
        }
      }
      
    }
  }
  
}
