import Foundation
import ComposableArchitecture
import Photos
import SwiftUI

// MARK: AuthorizationStatus
public enum AuthorizationStatus {
    case notDetermined
    case restricted
    case denied
    case authorized
    case limited
    
    internal init(status: PHAuthorizationStatus) {
        switch status {
        case .notDetermined:
            self = .notDetermined
        case .restricted:
            self = .restricted
        case .denied:
            self = .denied
        case .authorized:
            self = .authorized
        case .limited:
            self = .limited
        @unknown default:
            self = .notDetermined
        }
    }
}

extension AuthorizationStatus {
    public var isAuthorized: Bool {
        self == .authorized || self == .limited
    }
    
    public var isNotAuthorized: Bool {
        self == .denied || self == .restricted
    }
}

// MARK:
public enum FetchImageType {
    case thumbnail
    case original
}

// MARK: Load Image Response
@dynamicMemberLookup
public struct PhotosFetchResult: Equatable {
    var assets: PHFetchResult<PHAsset> = .init()
    private let imageManager: PHCachingImageManager = PHCachingImageManager()
    private let options = PHImageRequestOptions()
    
    public subscript<T>(dynamicMember keyPath: KeyPath<PHFetchResult<PHAsset>, T>) -> T {
        return assets[keyPath: keyPath]
    }
    
    public func fetchImage(imageType: FetchImageType, index: Int) -> Image? {
        let asset = assets.object(at: index)
        
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
        
        return resultImage
    }
}

@DependencyClient
public struct PhotosClient {
    public var requestAuthorization: @Sendable () async -> AuthorizationStatus = { .notDetermined }
    public var loadPhotos: @Sendable () -> PhotosFetchResult  = { .init() }
}

// MARK: DependencyValues
extension DependencyValues {
    public var photosClient: PhotosClient {
        get { self[PhotosClient.self] }
        set { self[PhotosClient.self] = newValue }
    }
}

extension PhotosClient: TestDependencyKey {
    public static var testValue = PhotosClient(
        requestAuthorization: unimplemented(),
        loadPhotos: unimplemented()
    )
}
