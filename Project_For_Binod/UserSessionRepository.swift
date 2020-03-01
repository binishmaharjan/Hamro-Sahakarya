//
//  UserSessionRepository.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/10/19.
//  Copyright © 2019 JEC. All rights reserved.
//

import Foundation
import PromiseKit

protocol UserSessionRepository {
  
  func readUserSession() -> Promise<UserSession?>
  func signUp(newAccount: NewAccount) -> Promise<UserSession>
  func signIn(email: String, password: String) -> Promise<UserSession>
  func signOut(userSession: UserSession) -> Promise<UserSession>
  
  func getLogs() -> Promise<[GroupLog]>
  
  func changeProfilePicture(userSession: UserSession, image: UIImage) -> Promise<UserSession>
  func getAllMembers() -> Promise<[UserProfile]>
}
