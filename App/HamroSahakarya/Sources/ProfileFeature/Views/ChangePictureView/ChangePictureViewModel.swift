import AppUI
import Core
import Foundation
import Photos
import RxCocoa
import RxSwift
import UIKit

public protocol ChangePictureStateProtocol {
    var selectedImage: UIImage? { get }
}

extension ChangePictureStateProtocol {
    public var isSaveButtonEnabled: Bool {
        return !selectedImage.isEmpty
    }
}

public protocol ChangePictureViewModel {
    var count: Int { get }
    var cellSize: CGSize { get }
    var selectedImage: BehaviorRelay<UIImage?> { get }
    var state: Driver<State> { get }
    var isSaveButtonEnabled: Observable<Bool> { get }
    
    func photoViewModel(forRowAt indexPath: IndexPath) -> PhotoCellViewModel
    func originalImage(at indexPath: IndexPath) -> UIImage?
    func changeProfilePicture()
    
    mutating func reloadPhotos()
}

public struct DefaultChangePictureViewModel: ChangePictureViewModel {
    public enum ImageType {
        case thumbnail
        case original
    }
    
    public struct UIState: ChangePictureStateProtocol {
        public var selectedImage: UIImage?
    }
    
    private var imageManager: PHCachingImageManager = PHCachingImageManager()
    private var photos: PHFetchResult<PHAsset> = DefaultChangePictureViewModel.loadPhotos()
    private let options = PHImageRequestOptions()
    private let userSession: UserSession
    private let userSessionRepository: UserSessionRepository
    
    @PropertyBehaviorRelay<State>(value: .idle)
    public var state: Driver<State>
    
    public let selectedImage: BehaviorRelay<UIImage?> = BehaviorRelay<UIImage?>(value: nil)
    public let isSaveButtonEnabled: Observable<Bool>
    
    public var count: Int {
        return photos.count
    }
    
    public var cellSize: CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let numberOfRows: CGFloat = 4
        let margin: CGFloat = 2.5
        let cellWidth = screenWidth / numberOfRows - (2 * margin)
        
        return .init(width: cellWidth, height: cellWidth)
    }
    
    public init(
        userSession: UserSession,
        userSessionRepository: UserSessionRepository
    ) {
        self.userSession = userSession
        self.userSessionRepository = userSessionRepository
        
        let state = selectedImage.asObservable().map { UIState(selectedImage: $0) }
        isSaveButtonEnabled = state.map { $0.isSaveButtonEnabled }
    }
    
    public func photoViewModel(forRowAt indexPath: IndexPath) -> PhotoCellViewModel {
        let phAssest = photos.object(at: indexPath.row)
        let image = getImage(asset: phAssest)
        
        return DefaultPhotoCellViewModel(image: image)
    }
    
    public func originalImage(at indexPath: IndexPath) -> UIImage? {
        let phAssest = photos.object(at: indexPath.row)
        let image = getImage(asset: phAssest, imageType: .original)
        
        return image
    }
    
    private static func loadPhotos() -> PHFetchResult<PHAsset> {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        return PHAsset.fetchAssets(with: allPhotosOptions)
    }
    
    private func getImage(asset: PHAsset,imageType: ImageType = .thumbnail) -> UIImage? {
        var resultImage: UIImage?
        var targetSize: CGSize
        
        options.isSynchronous = true
        
        switch imageType {
        case .thumbnail:
            targetSize = .init(width: 150, height: 150)
        case .original:
            targetSize = .init(width: asset.pixelWidth, height: asset.pixelHeight)
        }
        
        imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: PHImageContentMode.aspectFill, options: options) { (image, _) in
            resultImage = image
        }
        
        return resultImage
    }
    
    public func changeProfilePicture() {
        guard let image = selectedImage.value else { return }
        indicateLoading()
        userSessionRepository
            .changeProfilePicture(userSession: userSession, image: image)
            .done(indicateChangeProfileSuccess(userSession:))
            .catch(indicateError(error:))
    }
    
    public mutating func reloadPhotos() {
        photos = DefaultChangePictureViewModel.loadPhotos()
    }
}

// MARK: Api Indication
extension DefaultChangePictureViewModel {
    private func indicateLoading() {
        _state.accept(.loading)
    }
    
    private func indicateChangeProfileSuccess(userSession: UserSession) {
        _state.accept(.completed)
        // Renewing user information
        self.userSession.profile.accept(userSession.profile.value)
    }
    
    private func indicateError(error: Error) {
        _state.accept(.error(error))
    }
}
