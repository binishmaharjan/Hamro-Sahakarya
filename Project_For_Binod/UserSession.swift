//
//  UserSession.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/01/30.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation

final class UserSession {
  
  let profile: UserProfile
  
  init(profile: UserProfile) {
    self.profile = profile
  }
}

extension UserSession: Equatable {
  static func ==(lhs: UserSession, rhs: UserSession) -> Bool {
    return lhs.profile == rhs.profile
  }
}
