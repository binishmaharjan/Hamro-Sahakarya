//
//  UserProfilePropertyListCoder.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/11/09.
//  Copyright © 2019 JEC. All rights reserved.
//

import Foundation

final class UserProfilePropertyListCoder: UserProfileCoding {
  func encode(userSession: UserSession) -> Data {
    return try! PropertyListEncoder().encode(userSession)
  }
  
  func decode(data: Data) -> UserSession {
    return try! PropertyListDecoder().decode(UserSession.self, from: data)
  }
}

