//
//  HSUserSessionRepository.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/11/09.
//  Copyright © 2019 JEC. All rights reserved.
//

import Foundation
import PromiseKit

class FirebaseUserSessionRepository: UserSessionRepository {
  
  // MARK: Properties
  private let dataStore: UserDataStore
  private let remoteApi: AuthRemoteApi
  private let serverDataManager: ServerDataManager
  
  // MARK: Init
  init(dataStore: UserDataStore, remoteApi: AuthRemoteApi, serverDataManager: ServerDataManager) {
    self.dataStore = dataStore
    self.remoteApi = remoteApi
    self.serverDataManager = serverDataManager
  }
  
  // MARK: Methods
  /// Read user session from the local data store
  func readUserSession() -> Promise<UserProfile?> {
    return dataStore.readUserProfile()
  }
  
  
  /// Signup the user and save the user data to the local data store
  func signUp(newAccount: NewAccount) -> Promise<UserProfile> {

    let signUpTheUser = remoteApi.signUp(newAccount: newAccount)
    let saveDataToServer = signUpTheUser.then { (uid) -> Promise<UserProfile> in
      
      let userProifile = UserProfile(uid: uid,
                                     username: newAccount.username,
                                     email: newAccount.email,
                                     status: newAccount.status,
                                     colorHex: newAccount.colorHex,
                                     iconUrl: "",
                                     dateCreated: Date().toString,
                                     keyword: newAccount.keyword,
                                     loanTaken: 0,
                                     balance: newAccount.initialAmount,
                                     dateUpdated: Date().toString)
      
      return self.serverDataManager.saveUser(userProfile: userProifile)
    }
    
    let saveUserToDataStore = saveDataToServer.then(dataStore.save(userProfile:))
    
    return saveUserToDataStore
    
  }
  
  /// Signin the uset and save the user data to the local data store
  func signIn(email: String, password: String) -> Promise<UserProfile> {
    
    let signInTheUser = remoteApi.signIn(email: email, password: password)
    let readUserFromServer = signInTheUser.then(serverDataManager.readUser(uid:))
    
    let saveUserToDataStore = readUserFromServer.then{ [weak self] (userProfile) -> Promise<UserProfile> in
      return (self?.dataStore.save(userProfile: userProfile!))!
    }
    
    return saveUserToDataStore
    
  }
  
  func signOut(userProfile: UserProfile) -> Promise<UserProfile> {
    return dataStore.delete(userProfile: userProfile)
  }
  
  
}
