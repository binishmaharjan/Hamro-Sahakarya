//
//  ServerDataManager.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/11/09.
//  Copyright © 2019 JEC. All rights reserved.
//

import Foundation
import PromiseKit

protocol ServerDataManager {
  
  func saveUser(userSession: UserSession) -> Promise<UserSession>
  func readUser(uid: String) -> Promise<UserSession?>
  
}
