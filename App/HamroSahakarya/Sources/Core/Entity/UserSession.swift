import Foundation
import RxCocoa

/// Class Wrapper for User Profile
/// Because of this class, Core Module needs to depend on RxSwift
/// Move this class to other module
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
