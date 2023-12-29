import Foundation
import SwiftUI
import Dependencies
import SharedModels
import FirebaseStorage

// MARK: Dependency (liveValue)
extension UserStorageClient: DependencyKey {
    public static let liveValue = UserStorageClient.live()
}

// MARK: - Live Implementation
extension UserStorageClient {
    public static func live() -> UserStorageClient {
        let session = Session()
        
        return UserStorageClient(
            saveImage: { try await session.saveImage(user: $0, image: $1) },
            downloadTermsAndCondition: { try await session.downloadTermsAndCondition() }
        )
    }
}

extension UserStorageClient {
    actor Session {
        func saveImage(user: Account, image: Image) async throws -> URL {
            fatalError()
        }
        
        func downloadTermsAndCondition() async throws -> Data {
            fatalError()
        }
    }
}
