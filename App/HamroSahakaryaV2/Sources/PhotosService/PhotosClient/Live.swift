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
            loadPhotos: { await session.loadPhotos() },
            fetchImage: { await session.fetchImage(for: $0, asset: $1) }
        )
    }
}

extension PhotosClient {
    actor Session {
        
        private var imageManager: PHCachingImageManager = PHCachingImageManager()
        private let options = PHImageRequestOptions()
        
        func requestAuthorization() async -> AuthorizationStatus {
            let status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
            return AuthorizationStatus(status: status)
        }
        
        func loadPhotos() async -> LoadPhotoResponse {
            return await withCheckedContinuation { continuation in
                let allPhotosOptions = PHFetchOptions()
                allPhotosOptions.sortDescriptors = [
                    NSSortDescriptor(key: "creationDate", ascending: false)
                ]
                continuation.resume(
                    returning: LoadPhotoResponse(assets: PHAsset.fetchAssets(with: allPhotosOptions))
                )
            }
        }
        
        func fetchImage(for imageType: FetchImageType, asset: PHAsset) async -> Image? {
            return await withCheckedContinuation { continuation in
                var resultImage: Image?
                let targetSize: CGSize = switch imageType {
                case .thumbnail: .init(width: 150, height: 150)
                case .original: .init(width: asset.pixelWidth, height: asset.pixelHeight)
                }

                options.isSynchronous = true
                
                imageManager.requestImage(
                    for: asset,
                    targetSize: targetSize,
                    contentMode: .aspectFill,
                    options: options) { image, _ in
                        if let image {
                            resultImage = Image(uiImage: image)
                        }
                    }
                
                continuation.resume(returning: resultImage)
            }
        }
    }
}
