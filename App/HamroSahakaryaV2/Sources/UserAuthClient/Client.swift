import Foundation
import Dependencies
import SharedModels

public struct UserAuthClient {
    /// SignIn the user.
    ///
    /// - Parameters:
    ///   - email: Email Id of user
    ///   - password: Password for the account
    /// - Returns: UserId
    public var signIn: @Sendable (Email, Password) async throws -> UserId
    /// Create new account for the user. Only Admin can create new accounts
    ///
    /// - Parameter newAccount: User info for the new account
    /// - Returns: UserId
    public var createUser: @Sendable (NewUser) async throws -> UserId
    /// SignOut User
    ///
    /// - Parameter none
    /// - Returns: Void
    public var signOut: @Sendable () async throws -> Void
    /// Change User Password
    ///
    /// - Parameter newPassword: The new password user wants to set
    /// - Returns: Void
    public var changePassword: @Sendable (Password) async throws -> Void
    /// Send Password Reset Email
    ///
    /// - Parameter email: User email id associated with user account.
    /// - Returns: Void
    public var sendPasswordReset: @Sendable (Email) async throws -> Void
}

// MARK: DependencyValues
extension DependencyValues {
    public var userAuthClient: UserAuthClient {
        get { self[UserAuthClient.self] }
        set { self[UserAuthClient.self] = newValue }
    }
}

// MARK: Dependency (testValue, previewValue)
extension UserAuthClient: TestDependencyKey {
    public static let testValue = UserAuthClient(
        signIn: unimplemented(),
        createUser: unimplemented(),
        signOut: unimplemented(),
        changePassword: unimplemented(),
        sendPasswordReset: unimplemented()
    )

    public static let previewValue = UserAuthClient(
        signIn: unimplemented(),
        createUser: unimplemented(),
        signOut: unimplemented(),
        changePassword: unimplemented(),
        sendPasswordReset: unimplemented()
    )
}
