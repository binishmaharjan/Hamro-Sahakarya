//
//  UserSession.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/01/30.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation
import RxCocoa

/// Class Wrapper for User Profile
final class UserSession {
    var profile: BehaviorRelay<UserProfile>
    
    init(profile: UserProfile) {
        self.profile = BehaviorRelay(value: profile)
    }
}


extension UserSession: Equatable {
    static func ==(lhs: UserSession, rhs: UserSession) -> Bool {
        return lhs.profile.value == rhs.profile.value
    }
}

extension UserSession {
    var isAdmin: Bool {
        return profile.value.status == .admin
    }
}
