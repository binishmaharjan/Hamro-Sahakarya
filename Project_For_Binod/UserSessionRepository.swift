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
  
  func readUserSession() -> Promise<UserProfile?>
  func signUp(newAccount: NewAccount) -> Promise<UserProfile>
  func signIn(email: String, password: String) -> Promise<UserProfile>
  func signOut(userProfile: UserProfile) -> Promise<UserProfile>
}
