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
public struct LoadPhotoResponse: Equatable {
    var assets: PHFetchResult<PHAsset> = .init()
    
    public subscript<T>(dynamicMember keyPath: KeyPath<PHFetchResult<PHAsset>, T>) -> T {
        return assets[keyPath: keyPath]
    }
}

@DependencyClient
public struct PhotosClient {
    public var requestAuthorization: @Sendable () async -> AuthorizationStatus = { .notDetermined }
    public var loadPhotos: @Sendable () async -> LoadPhotoResponse = { .init() }
    public var fetchImage: @Sendable(FetchImageType, PHAsset) async -> Image?
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
        loadPhotos: unimplemented(),
        fetchImage: unimplemented()
    )
}
