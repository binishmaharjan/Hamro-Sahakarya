import Foundation
import RxCocoa

/// Class Wrapper for User Profile
public final class UserSession {
    public var profile: BehaviorRelay<UserProfile>

    public init(profile: UserProfile) {
        self.profile = BehaviorRelay(value: profile)
    }
}


extension UserSession: Equatable {
    public static func ==(lhs: UserSession, rhs: UserSession) -> Bool {
        return lhs.profile.value == rhs.profile.value
    }
}

extension UserSession {
    public var isAdmin: Bool {
        return profile.value.status == .admin
    }
}
