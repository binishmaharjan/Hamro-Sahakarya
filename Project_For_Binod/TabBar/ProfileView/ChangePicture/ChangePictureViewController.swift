//
//  ChangePictureViewController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/02/04.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit
import Photos
import RxSwift
import RxCocoa

final class ChangePictureViewController: UIViewController {
  
  // MARK: IBOutlet
  @IBOutlet private weak var collectionView: UICollectionView!
  @IBOutlet private weak var previewImageViewArea: UIView!
  let previewImageView = PreviewImageView.loadXib()
  
  private let disposeBag = DisposeBag()
  private var viewModel: ChangePictureViewModel!
  
  // MARK: LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.registerXib(of: PhotoCell.self)
    
    setupBarButton()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    bindPhotoLibraryAuthorization()
    bindPhotoSelection()
    bindState()
  }
  
  private func setupBarButton() {
    let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonPressed))
    navigationItem.rightBarButtonItem = saveButton
  }
  
  @objc private func saveButtonPressed() {
    viewModel.changeProfilePicture()
  }
  
  // MARK: Methods
  private func bindPhotoLibraryAuthorization() {
    // Camera Access Permission
    let authorized = PHPhotoLibrary.authorized.share()
    
    authorized
      .skipWhile { $0 == false }
      .take(1)
      .subscribe(onNext: { [weak self] _ in
        DispatchQueue.main.async {
          self?.viewModel.reloadPhotos()
          self?.collectionView?.reloadData()
        }
      })
      .disposed(by: disposeBag)

    authorized
      .skip(1)
      .takeLast(1)
      .filter { $0 == false }
      .subscribe(onNext: { [weak self] _ in
        guard let noPermissionErrorDisplay = self?.noPermissionErrorDisplay else { return }
        DispatchQueue.main.async(execute: noPermissionErrorDisplay)
      })
      .disposed(by: disposeBag)
  }
  
  private func bindPhotoSelection() {
    viewModel.selectedImage
      .asObservable()
      .bind(onNext: createPreview(with:))
      .disposed(by: disposeBag)
  }
  
  private func bindState() {
      viewModel.state
        .drive(onNext: { [weak self] (state) in
          
          guard let this = self else { return }
          
          switch state {
          case .idle:
            break
            
          case .completed:
            GUIManager.shared.stopAnimation()
            this.navigationController?.popViewController(animated: true)
            
          case .error(let error):
            GUIManager.shared.stopAnimation()
            
            let dropDownModel = DropDownModel(dropDownType: .error, message: error.localizedDescription)
            GUIManager.shared.showDropDownNotification(data: dropDownModel)
            
          case .loading:
            GUIManager.shared.startAnimation()
          }
        }).disposed(by: disposeBag)
  }
  
  private func noPermissionErrorDisplay() {
    let title = "No Permission"
    let message = "You can grant access from the Settings app"
    GUIManager.shared.showDialog(title: title, message: message, type: .notice) { [weak self] in
      self?.dismiss(animated: true)
      self?.navigationController?.popViewController(animated: true)
    }
  }
  
  private func createPreview(with image: UIImage?) {
    removeAllSubViews(from: previewImageViewArea)
    
    let previewImageView = PreviewImageView.makeInstance(with: image)
    previewImageViewArea.addSubview(previewImageView)
       previewImageView.translatesAutoresizingMaskIntoConstraints = false
       NSLayoutConstraint.activate([
         previewImageView.topAnchor.constraint(equalTo: previewImageViewArea.topAnchor),
         previewImageView.bottomAnchor.constraint(equalTo: previewImageViewArea.bottomAnchor),
         previewImageView.leadingAnchor.constraint(equalTo: previewImageViewArea.leadingAnchor),
         previewImageView.trailingAnchor.constraint(equalTo: previewImageViewArea.trailingAnchor),
       ])
  }
  
  private func removeAllSubViews(from view: UIView) {
    view.subviews.forEach{ $0.removeFromSuperview() }
  }
  
}

// MARK: Storyboard Instantiable
extension ChangePictureViewController: StoryboardInstantiable {
  static func makeInstance(viewModel: ChangePictureViewModel) -> ChangePictureViewController {
    let viewController = ChangePictureViewController.loadFromStoryboard()
    viewController.viewModel = viewModel
    return viewController
  }
  
}

// MARK: Collection View Delegate
extension ChangePictureViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return viewModel.cellSize
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let image = viewModel.originalImage(at: indexPath)
    viewModel.selectedImage.accept(image)
  }
  
}

// MARK: Collection View DataSource
extension ChangePictureViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueCell(of: PhotoCell.self, for: indexPath)
    let cellViewModel = viewModel.photoViewModel(forRowAt: indexPath)
    cell.bind(viewModel: cellViewModel)
    
    return cell
  }
  
  
}

// MARK: Collection View FlowLayout Delegate
extension ChangePictureViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
      return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 2.5
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 2.5
  }
}
