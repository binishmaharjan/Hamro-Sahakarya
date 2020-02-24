//
//  ChangePictureViewModel.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/02/16.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation
import Photos
import RxSwift
import RxCocoa

protocol ChangePictureStateProtocol {
  var selectedImage: UIImage? { get }
}

extension ChangePictureStateProtocol {
  var isSaveButtonEnabled: Bool {
    return !selectedImage.isEmpty
  }
}

protocol ChangePictureViewModel {
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

struct DefaultChangePictureViewModel: ChangePictureViewModel {

  enum ImageType {
    case thumbnail
    case original
  }
  
  struct UIState: ChangePictureStateProtocol {
    var selectedImage: UIImage?
  }

  private var imageManager: PHCachingImageManager = PHCachingImageManager()
  private var photos: PHFetchResult<PHAsset> = DefaultChangePictureViewModel.loadPhotos()
  private let options = PHImageRequestOptions()
  private let userSession: UserSession
  private let userSessionRepository: UserSessionRepository
  
  @PropertyBehaviourRelay<State>(value: .idle)
   var state: Driver<State>
  
  let selectedImage: BehaviorRelay<UIImage?> = BehaviorRelay<UIImage?>(value: nil)
  let isSaveButtonEnabled: Observable<Bool>
  
  var count: Int {
    return photos.count
  }
  
  var cellSize: CGSize {
    let screenWidth = UIScreen.main.bounds.width
    let numberOfRows: CGFloat = 4
    let margin: CGFloat = 2.5
    let cellWidth = screenWidth / numberOfRows - (2 * margin)
    
    return .init(width: cellWidth, height: cellWidth)
  }
  
  init(userSession: UserSession, userSessionRepository: UserSessionRepository) {
    self.userSession = userSession
    self.userSessionRepository = userSessionRepository
    
    let state = selectedImage.asObservable().map { UIState(selectedImage: $0) }
    isSaveButtonEnabled = state.map { $0.isSaveButtonEnabled }
  }
  
  func photoViewModel(forRowAt indexPath: IndexPath) -> PhotoCellViewModel {
    let phAssest = photos.object(at: indexPath.row)
    let image = getImage(asset: phAssest)
    
    return DefaultPhotoCellViewModel(image: image)
  }
  
  func originalImage(at indexPath: IndexPath) -> UIImage? {
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
  
  func changeProfilePicture() {
    guard let image = selectedImage.value else { return }
    indicateLoading()
    userSessionRepository
      .changeProfilePicture(userSession: userSession, image: image)
      .done(indicateChangeProfileSuccess(userSession:))
      .catch(indicateError(error:))
  }
  
  mutating func reloadPhotos() {
    photos = DefaultChangePictureViewModel.loadPhotos()
  }
  
}

// MARK: Api Inidication
extension DefaultChangePictureViewModel {
  
  private func indicateLoading() {
    _state.accept(.loading)
  }
  
  private func indicateChangeProfileSuccess(userSession: UserSession) {
    _state.accept(.completed)
  }
  
  private func indicateError(error: Error) {
    _state.accept(.error(error))
  }
  
}
