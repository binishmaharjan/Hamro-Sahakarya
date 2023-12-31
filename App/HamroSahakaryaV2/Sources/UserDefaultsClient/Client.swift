import Foundation
import Dependencies
import SharedModels

public struct UserDefaultsClient {
    /// Get User Account Info From UserDefaults
    public var user: () -> User?
    /// Save User Account Info To UserDefaults
    public var saveUser: (User) -> Void
    /// Delete Current User Account Info From UserDefaults
    public var deleteUser: () -> Void
}

// MARK: DependencyValues
extension DependencyValues {
    public var userDefaultsClient: UserDefaultsClient {
        get { self[UserDefaultsClient.self] }
        set { self[UserDefaultsClient.self] = newValue }
    }
}


// MARK: Dependency (testValue, previewValue)
extension UserDefaultsClient: TestDependencyKey {
    public static let testValue = UserDefaultsClient(
        user: unimplemented(),
        saveUser: unimplemented(),
        deleteUser: unimplemented()
    )

    public static let previewValue = UserDefaultsClient(
        user: { .mock },
        saveUser: unimplemented(),
        deleteUser: unimplemented()
    )
}

// MARK: Mock
extension User {
    public static var mock: User = User(
        id: "62x2j84hM9YCSrtiNwhg2F86NSv2",
        username: "Member One",
        email: "memberone@gmail.com",
        status: .admin,
        colorHex: "2A80FF",
        dateCreated: "2020-05-26 13:44:32.715",
        keyword: "password",
        loanTaken: 0,
        balance: 275000,
        dateUpdated: "2020-05-26 13:44:32.715"
    )
}
