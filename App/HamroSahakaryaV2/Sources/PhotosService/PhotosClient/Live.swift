import Foundation
import ComposableArchitecture
import Photos
import SwiftUI

extension PhotosClient: DependencyKey {
    public static var liveValue = PhotosClient.live()
}

extension PhotosClient {
    public static func live() -> PhotosClient {
        let session = Session()
        
        return PhotosClient(
            requestAuthorization: { await session.requestAuthorization() },
            loadPhotos: { session.loadPhotos() }
        )
    }
}

extension PhotosClient {
    actor Session {
        func requestAuthorization() async -> AuthorizationStatus {
            let status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
            return AuthorizationStatus(status: status)
        }
        
        nonisolated func loadPhotos() -> PhotosFetchResult {
            let allPhotosOptions = PHFetchOptions()
            allPhotosOptions.sortDescriptors = [
                NSSortDescriptor(key: "creationDate", ascending: false)
            ]
            return PhotosFetchResult(assets: PHAsset.fetchAssets(with: allPhotosOptions))
        }
    }
}
