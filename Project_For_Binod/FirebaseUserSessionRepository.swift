//
//  HSUserSessionRepository.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/11/09.
//  Copyright © 2019 JEC. All rights reserved.
//

import Foundation
import PromiseKit
import FirebaseAuth

final class FirebaseUserSessionRepository: UserSessionRepository {

  // MARK: Properties
  private let dataStore: UserDataStore
  private let remoteApi: AuthRemoteApi
  private let serverDataManager: ServerDataManager
  private let logApi: LogRemoteApi
  
  // MARK: Init
  init(dataStore: UserDataStore, remoteApi: AuthRemoteApi, serverDataManager: ServerDataManager, logApi: LogRemoteApi) {
    self.dataStore = dataStore
    self.remoteApi = remoteApi
    self.serverDataManager = serverDataManager
    self.logApi = logApi
  }
  
  // MARK: User
  /// Read user session from the local data store
  ///
  /// - Return Promise<UserProfile> : UserInfo wrapped in promise
  func readUserSession() -> Promise<UserProfile?> {
    return dataStore.readUserProfile()
  }
  
  
  /// Signup the user and save the user data to the local data store
  ///
  /// - Parameter newAccount: User info for the new account
  /// - Return Promise<UserProfile> : UserInfo wrapped in promise
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
  ///
  /// - Parameter email: Email Id of user
  /// - Parameter password: Password
  /// - Return Promise<UserProfile> : UserInfo wrapped in promise
  func signIn(email: String, password: String) -> Promise<UserProfile> {
    
    let signInTheUser = remoteApi.signIn(email: email, password: password)
    let readUserFromServer = signInTheUser.then(serverDataManager.readUser(uid:))
    
    let saveUserToDataStore = readUserFromServer.then{ [weak self] (userProfile) -> Promise<UserProfile> in
      return (self?.dataStore.save(userProfile: userProfile!))!
    }
    
    return saveUserToDataStore
    
  }
  
  func signOut(userProfile: UserProfile) -> Promise<UserProfile> {
    // Firebase Signout
    try? Auth.auth().signOut()
    
    // Data Deletion
    return dataStore.delete(userProfile: userProfile)
  }
  
  // MARK: Logs
  
  /// Get all the group logs
  ///
  /// - Return Promise<UserProfile> : logs wrapped in promise
  func getLogs() -> Promise<[GroupLog]> {
    return logApi.getLogs()
  }
  
}
