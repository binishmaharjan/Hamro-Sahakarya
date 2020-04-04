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
  private let storageApi: StorageRemoteApi
  
  // MARK: Init
  init(dataStore: UserDataStore, remoteApi: AuthRemoteApi, serverDataManager: ServerDataManager, logApi: LogRemoteApi, storageApi: StorageRemoteApi) {
    self.dataStore = dataStore
    self.remoteApi = remoteApi
    self.serverDataManager = serverDataManager
    self.logApi = logApi
    self.storageApi = storageApi
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
    
    let addLog = saveUserToDataStore.then(logApi.addJoinedLog(userSession:))
    
    return addLog
    
  }
  
  /// Signin the uset and save the user data to the local data store
  ///
  /// - Parameter email: Email Id of user
  /// - Parameter password: Password
  /// - Return Promise<UserSession> : UserInfo wrapped in promise
  func signIn(email: String, password: String) -> Promise<UserSession> {
    return remoteApi.signIn(email: email, password: password)
      .then(serverDataManager.readUser(uid:))
      .then(dataStore.save(userSession:))
  }
  
  /// Signout User
  ///
  /// - Parameter userSession: Current User Session
  /// - Return Promise<UserSession> : UserInfo wrapped in promise
  func signOut(userSession: UserSession) -> Promise<UserSession> {
    return remoteApi.signOut(userSession: userSession)
      .then(dataStore.delete(userSession:))
  }
  
  /// Change User Password
  ///
  /// - Parameter userSession: Current User Session
  /// - Parameter newPassowrd: NewPassword
  /// - Return Promise<Void> : Void wrapped in promise
  func changePassword(userSession: UserSession, newPassword: String) -> Promise<String> {
    return remoteApi.changePassword(newPassword: newPassword)
      .map { (userSession, $0) }
      .then(serverDataManager.updatePassword(userSession: newPassowrd:))
  }
  
  // MARK: Logs
  
  /// Get all the group logs
  ///
  /// - Return Promise<[Group Log]> : logs wrapped in promise
  func getLogs() -> Promise<[GroupLog]> {
    return logApi.getLogs()
  }
  
  func addMonthlyFeeLog(admin: UserProfile, user: UserProfile, amount: Int) -> Promise<Void> {
    return serverDataManager.addMonthlyFee(for: user, amount: amount)
      .map { (admin, user, amount) }
      .then(logApi.addMonthlyFeeLog(admin: userProfile: amount: ))
  }
  
  /// Change Member Status
  ///
  /// - Parameter user: The specific user whose status is to be changed
  /// - Return Promise<Void> : returns  a empty promise
  func changeStatus(for user: UserProfile) -> Promise<Void> {
    return serverDataManager.changeStatus(for: user)
  }
  
  /// Get All Members
  ///
  /// - Return Promise<[UserProfile]>: All member list wrapped in promise
  func getAllMembers() -> Promise<[UserProfile]> {
    return serverDataManager.getAllMembers()
  }
  
  // MARK: Storage

  /// Change the profile picture
  ///
  /// - Parameter userSession: User Profile Information
  /// - Parameter image: New Image
  /// - Return Promise<URL> : Url of saved image wrapped in promise
  func changeProfilePicture(userSession: UserSession, image: UIImage) -> Promise<UserSession> {
    return storageApi.saveImage(userSession: userSession, image: image)
      .map { (userSession, $0) }
      .then(serverDataManager.updateProfileUrl(userSession: url:))
      .then(serverDataManager.readUser(uid:))
      .then(dataStore.save(userSession:))
  }
}


