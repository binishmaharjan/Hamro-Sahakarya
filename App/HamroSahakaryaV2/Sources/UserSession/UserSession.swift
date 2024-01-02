import Foundation
import ComposableArchitecture
import SharedModels

public struct UserSession: Equatable {
    public init(user: User) {
        self.user = user
    }
    
    public var user: User
}

// MARK: Helper Method
extension UserSession {
    public static func createUserSession(from user: User) -> UserSession {
        UserSession(user: user)
    }
}

// MARK: MOck
extension UserSession {
    public static var mock: UserSession {
        UserSession(user: .mock)
    }
}
