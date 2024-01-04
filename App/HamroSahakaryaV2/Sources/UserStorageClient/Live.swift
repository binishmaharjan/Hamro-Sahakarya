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
        func saveImage(user: User, image: UIImage) async throws -> URL {
            let metaData = getMetaData(for: .jpeg)
            let uuid = user.id
            
            try await putData(image: image, metaData: metaData, uuid: uuid)
            return try await downloadImageUrl(for: uuid)
        }
        
        func downloadTermsAndCondition() async throws -> Data {
            let storage = Storage.storage()
            let pdfReference = storage.reference(withPath: "terms_and_condition/terms_and_conditions.pdf")
            
            return try await withCheckedThrowingContinuation { continuation in
                pdfReference.getData(maxSize: 3 * 1024 * 1024) { data, error in
                    
                    if let error { continuation.resume(throwing: error) }
                    guard let data else {
                        continuation.resume(throwing: AppError.ApiError.emptyData)
                        return
                    }
                    
                    continuation.resume(returning: data)
                }
            }
        }
    }
}

// MARK:  Helper Method
extension UserStorageClient.Session {
    enum ContentType: String {
        case jpeg = "image/jpeg"
    }
    
    private func generateStorageReference(for uuid: UserId) -> FirebaseStorage.StorageReference {
        let storageReference = Storage.storage().reference().child("user_profile/\(uuid)/profile_image.jpg")
        return storageReference
    }
    
    private func getMetaData(for contentType: ContentType) -> StorageMetadata {
        let metaData = StorageMetadata()
        metaData.contentType = contentType.rawValue
        return metaData
    }
    
    private func putData(image: UIImage, metaData: StorageMetadata, uuid: UserId) async throws -> Void {
        let storageReference = generateStorageReference(for: uuid)
        let imageData = image.jpegData(compressionQuality: 0.5)!
        _ = try await storageReference.putDataAsync(imageData, metadata: metaData)
    }
    
    private func downloadImageUrl(for uuid: UserId) async throws -> URL {
        let storageReference = generateStorageReference(for: uuid)
        let imageUrl = try await storageReference.downloadURL()
        return imageUrl
    }
}
