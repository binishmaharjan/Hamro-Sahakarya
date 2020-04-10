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
    func readUserProfile() -> Promise<UserSession?>
    func save(userSession: UserSession?) -> Promise<UserSession>
    func delete(userSession: UserSession) -> Promise<UserSession>
}
