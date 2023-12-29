import Foundation
import SwiftUI
import Dependencies
import SharedModels

public struct UserStorageClient {
    /// Save user profile image to storage
    ///
    /// - Parameters:
    ///   - user: User account to save user profile image
    ///   - image: UIImageData
    /// - Returns: URL in the storage
    public var saveImage: @Sendable (Account, Image) async throws -> URL
    /// Download terms and condition pdf
    ///
    /// - Parameters: none
    /// - Returns: PDF data
    public var downloadTermsAndCondition: @Sendable () async throws -> Data
}

// MARK: DependencyValues
extension DependencyValues {
    public var userStorageClient: UserStorageClient {
        get { self[UserStorageClient.self] }
        set { self[UserStorageClient.self] = newValue }
    }
}

extension UserStorageClient: TestDependencyKey {
    public static var testValue = UserStorageClient(
        saveImage: unimplemented(),
        downloadTermsAndCondition: unimplemented()
    )
    
    public static var previewValue = UserStorageClient(
        saveImage: unimplemented(),
        downloadTermsAndCondition: unimplemented()
    )
}
