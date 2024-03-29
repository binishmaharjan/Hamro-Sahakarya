import AppUI
import Core
import Photos
import RxSwift
import RxCocoa
import UIKit

public final class ChangePictureViewController: UIViewController {

    // MARK: IBOutlet
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var previewImageViewArea: UIView!
    @IBOutlet private weak var previewImageView: UIImageView!
    //  let previewImageView = PreviewImageView.loadXib()

    private let disposeBag = DisposeBag()
    private var viewModel: ChangePictureViewModel!

    // MARK: LifeCycle
    public override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerXib(of: PhotoCell.self, bundle: .module)

        setupBarButton()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bindPhotoLibraryAuthorization()
        bindPhotoSelection()
        bindApiState()
    }

    private func setupBarButton() {
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonPressed))
        navigationItem.rightBarButtonItem = saveButton

        viewModel.isSaveButtonEnabled
            .asDriver(onErrorJustReturn: true)
            .drive(saveButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }

    @objc private func saveButtonPressed() {
        viewModel.changeProfilePicture()
    }

    // MARK: Methods
    private func bindPhotoLibraryAuthorization() {
        // Camera Access Permission
        let authorized = PHPhotoLibrary.authorized.share()

        authorized
            .skip { $0 == false }
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
        //    viewModel.selectedImage
        //      .asObservable()
        //      .bind(onNext: createPreview(with:))
        //      .disposed(by: disposeBag)

        // Output
        viewModel.selectedImage
            .asDriver(onErrorJustReturn: nil)
            .drive(previewImageView.rx.image)
            .disposed(by: disposeBag)
    }

    private func bindApiState() {
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
        GUIManager.shared.showDialog(factory: .noPhotoPermission) { [weak self] in
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
    public static func makeInstance(viewModel: ChangePictureViewModel) -> ChangePictureViewController {
        let viewController = ChangePictureViewController.loadFromStoryboard(bundle: .module)
        viewController.viewModel = viewModel
        return viewController
    }
}

// MARK: Collection View Delegate
extension ChangePictureViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.cellSize
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = viewModel.originalImage(at: indexPath)
        viewModel.selectedImage.accept(image)
    }

}

// MARK: Collection View DataSource
extension ChangePictureViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(of: PhotoCell.self, for: indexPath)
        let cellViewModel = viewModel.photoViewModel(forRowAt: indexPath)
        cell.bind(viewModel: cellViewModel)

        return cell
    }
}

// MARK: Collection View FlowLayout Delegate
extension ChangePictureViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.5
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.5
    }
}

// MARK: Get Associated View
extension ChangePictureViewController: ViewControllerWithAssociatedView {
    public func getAssociateView() -> ProfileMainView {
        return .changePicture
    }
}
