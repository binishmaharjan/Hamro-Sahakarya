import AppUI
import Core
import RxCocoa
import RxSwift
import UIKit

public final class UpdateNoticeViewController: UIViewController {
    // MARK: IBOutlets
    @IBOutlet private weak var noticeTextView: UITextView!
    @IBOutlet private weak var updateNoticeButton: MainOrangeButton!
    
    // MARK: Properties
    private var viewModel: UpdateNoticeViewModelProtocol!
    private var disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        bindApiState()
        bindUIState()
    }
    
    @IBAction private func updateNoticeButtonPressed(_ sender: Any) {
        viewModel.updateNotice()
    }
}

// MARK: Setup
extension UpdateNoticeViewController {
    private func setup() {
        title = "Update Notice"
    }
}

// MARK: Storyboard Instantiable
extension UpdateNoticeViewController: StoryboardInstantiable {
    public static func makeInstance(viewModel: UpdateNoticeViewModelProtocol) -> UpdateNoticeViewController {
        let viewController = UpdateNoticeViewController.loadFromStoryboard()
        viewController.viewModel = viewModel
        return viewController
    }
}

// MARK: Bindable
extension UpdateNoticeViewController {
    private func bindApiState() {
        viewModel.apiState.driveNext { [weak self] state in
            switch state {
            case .completed:
                let dropDownModel = DropDownModel(dropDownType: .success, message: "Update Successful")
                GUIManager.shared.showDropDownNotification(data: dropDownModel)
                GUIManager.shared.stopAnimation()
                
                self?.navigationController?.popViewController(animated: true)
            case .error(let error):
                let dropDownModel = DropDownModel(dropDownType: .error, message: error.localizedDescription)
                GUIManager.shared.showDropDownNotification(data: dropDownModel)
                GUIManager.shared.stopAnimation()
            case .loading:
                GUIManager.shared.startAnimation()
            case .idle:
                break
            }
        }
        .disposed(by: disposeBag)
    }
    
    private func bindUIState() {
        // Input
        noticeTextView.rx.text
            .asDriver()
            .drive(viewModel.noticeInput)
            .disposed(by: disposeBag)
        
        // Output
        viewModel
            .isUpdateNoticeButtonEnabled
            .asDriver(onErrorJustReturn: false)
            .drive(updateNoticeButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}

// MARK: Get Associated View
extension UpdateNoticeViewController: ViewControllerWithAssociatedView {
    public func getAssociateView() -> ProfileMainView {
        return .updateNotice
    }
}
