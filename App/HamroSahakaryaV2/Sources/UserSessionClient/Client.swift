import Foundation
import Dependencies
import SharedModels

public struct UserSessionClient {
    /// Get User Account Info From Memory and save it to UserSession
    public var read: () -> User?
    /// Save User Account Info To UserSession
    public var save: (User) -> Void
    /// Delete Current User Account Info From UserSession and from Memory
    public var delete: () -> Void
}

// MARK: DependencyValues
extension DependencyValues {
    public var userSessionClient: UserSessionClient {
        get { self[UserSessionClient.self] }
        set { self[UserSessionClient.self] = newValue }
    }
}


// MARK: Dependency (testValue, previewValue)
extension UserSessionClient: TestDependencyKey {
    public static let testValue = UserSessionClient(
        read: unimplemented(),
        save: unimplemented(),
        delete: unimplemented()
    )

    public static let previewValue = UserSessionClient(
        read: { .mock },
        save: unimplemented(),
        delete: unimplemented()
    )
}
