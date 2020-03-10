//
//  LogRemoteApi.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/01/19.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation
import PromiseKit

protocol LogRemoteApi {
  func getLogs() -> Promise<[GroupLog]>
  func addJoinedLog(userSession: UserSession) -> Promise<UserSession>
}
