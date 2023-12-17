import Foundation
import Dependencies
import SharedModels

public struct AuthClient {
    /// SignIn the user.
    ///
    /// - Parameter email: Email Id of user
    /// - Parameter password: Password
    /// - Return AccountId : User Account Information
    public var signIn: @Sendable (Email, Password) async throws -> AccountId
    /// Create new account for the user. Only Admin can create new accounts
    ///
    /// - Parameter newAccount: User info for the new account
    /// - Return AccountId : User Account Information
    public var signUp: @Sendable (NewAccount) async throws -> AccountId
    /// SignOut User
    ///
    /// - Parameter none
    /// - Return Void
    public var signOut: @Sendable () async throws -> Void
    /// Change User Password
    ///
    /// - Parameter newPassword: NewPassword
    /// - Return Void
    public var changePassword: @Sendable (Password) async throws -> Void
}

// MARK: DependencyValues
extension DependencyValues {
    public var authClient: AuthClient {
        get { self[AuthClient.self] }
        set { self[AuthClient.self] = newValue }
    }
}


// MARK: Dependency (testValue, previewValue)
extension AuthClient: TestDependencyKey {
    public static let testValue = AuthClient(
        signIn: unimplemented(),
        signUp: unimplemented(),
        signOut: unimplemented(),
        changePassword: unimplemented()
    )

    public static let previewValue = AuthClient(
        signIn: unimplemented(),
        signUp: unimplemented(),
        signOut: unimplemented(),
        changePassword: unimplemented()
    )
}
