//
//  UserDataStore.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/11/09.
//  Copyright © 2019 JEC. All rights reserved.
//

import Foundation
import PromiseKit

protocol UserDataStore {
  func readUserProfile() -> Promise<UserProfile?>
  func save(userProfile: UserProfile) -> Promise<UserProfile>
  func delete(userProfile: UserProfile) -> Promise<UserProfile>
}
