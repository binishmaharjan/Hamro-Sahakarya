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
  /// - Return Promise<UserSession> : UserInfo wrapped in promise
  func readUserSession() -> Promise<UserSession?> {
    return dataStore.readUserProfile()
  }
  
  
  /// Signup the user and save the user data to the local data store
  ///
  /// - Parameter newAccount: User info for the new account
  /// - Return Promise<UserSession> : UserInfo wrapped in promise
  func signUp(newAccount: NewAccount) -> Promise<UserSession> {

    let signUpTheUser = remoteApi.signUp(newAccount: newAccount)
    let saveDataToServer = signUpTheUser.then { (uid) -> Promise<UserSession> in
      
      let userProifile = newAccount.createUserProfile(with: uid)
      
      let userSession = UserSession(profile: userProifile)
      
      return self.serverDataManager.saveUser(userSession: userSession)
    }
    
    let saveUserToDataStore = saveDataToServer.then(dataStore.save(userSession:))
    
    return saveUserToDataStore
    
  }
  
  /// Signin the uset and save the user data to the local data store
  ///
  /// - Parameter email: Email Id of user
  /// - Parameter password: Password
  /// - Return Promise<UserSession> : UserInfo wrapped in promise
  func signIn(email: String, password: String) -> Promise<UserSession> {
    
    let signInTheUser = remoteApi.signIn(email: email, password: password)
    let readUserFromServer = signInTheUser.then(serverDataManager.readUser(uid:))
    
    let saveUserToDataStore = readUserFromServer.then { [weak self] (userSession) -> Promise<UserSession> in
      return (self?.dataStore.save(userSession: userSession!))!
    }
    
    return saveUserToDataStore
    
  }
  
  func signOut(userSession: UserSession) -> Promise<UserSession> {
    return remoteApi.signOut(userSession: userSession)
      .then(dataStore.delete(userSession:))
  }
  
  // MARK: Logs
  
  /// Get all the group logs
  ///
  /// - Return Promise<[Group Log]> : logs wrapped in promise
  func getLogs() -> Promise<[GroupLog]> {
    return logApi.getLogs()
  }
  
}
