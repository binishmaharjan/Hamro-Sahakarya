//
//  UserProfilePropertyListCoder.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/11/09.
//  Copyright © 2019 JEC. All rights reserved.
//

import Foundation

class UserProfilePropertyListCoder: UserProfileCoding {
  func encode(userProfile: UserProfile) -> Data {
    return try! PropertyListEncoder().encode(userProfile)
  }
  
  func decode(data: Data) -> UserProfile {
    return try! PropertyListDecoder().decode(UserProfile.self, from: data)
  }
}

