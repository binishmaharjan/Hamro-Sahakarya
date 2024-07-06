import Foundation
import Dependencies
import SharedModels

// MARK: Dependency (liveValue)
extension UserSessionClient: DependencyKey {
    public static let liveValue = Self.live(
        userSession: .shared
    )
}

// MARK: - Live Implementation
extension UserSessionClient {
    public static func live(userSession: UserSession) -> Self {
        UserSessionClient(
            read: {
                userSession.read()
            },
            save: { user in
                userSession.save(user: user)
            },
            delete: {
                userSession.delete()
            }
        )
    }
}

