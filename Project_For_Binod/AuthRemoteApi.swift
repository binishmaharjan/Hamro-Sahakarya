//
//  AuthRemoteApi.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/11/09.
//  Copyright © 2019 JEC. All rights reserved.
//

import Foundation
import PromiseKit

protocol AuthRemoteApi {
  func signIn(email: String, password: String) -> Promise<String>
  func signUp(newAccount: NewAccount) -> Promise<String>
  func signOut(userSession: UserSession) -> Promise<UserSession>
  func changePassword(newPassword: String) -> Promise<String>
}
