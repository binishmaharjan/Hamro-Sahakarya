import AppUI
import Core
import RxCocoa
import RxSwift
import UIKit

public final class ChangePasswordViewController: KeyboardObservingViewController {
    // MARK: IBOutlets
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var confirmPasswordField: UITextField!
    @IBOutlet private weak var changePasswordButton: MainOrangeButton!

    private var viewModel: ChangePasswordViewModel!
    private let disposeBag = DisposeBag()

    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind()
        bindApiState()
    }

    private func setup() {
        title = "Change Password"
    }

    @IBAction func changePasswordButtonPressed(_ sender: Any) {
        viewModel.changePassword()
    }
}

// MARK: Bindable
extension ChangePasswordViewController {
    private func bind() {
        // Input
        passwordTextField.rx.text
            .asDriver().map { $0 ?? "" }
            .drive(viewModel.passwordInput)
            .disposed(by: disposeBag)

        confirmPasswordField.rx.text
            .asDriver().map { $0 ?? "" }
            .drive(viewModel.confirmPasswordInput)
            .disposed(by: disposeBag)

        // Output
        viewModel.isChangePasswordButtonEnabled
            .asDriver(onErrorJustReturn: true)
            .drive(changePasswordButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }

    private func bindApiState() {
        viewModel.apiState.drive(onNext: { [weak self] (state) in
            switch state {
            case .idle:
                break
            case .completed:
                GUIManager.shared.stopAnimation()

                let dropDownModel = DropDownModel(dropDownType: .success, message: "Change Password Successful")
                GUIManager.shared.showDropDownNotification(data: dropDownModel)

                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.viewModel.signOut()
                }
            case .error(let error):
                GUIManager.shared.stopAnimation()

                let dropDownModel = DropDownModel(dropDownType: .error, message: error.localizedDescription)
                GUIManager.shared.showDropDownNotification(data: dropDownModel)
            case .loading:
                GUIManager.shared.startAnimation()
            }
        }).disposed(by: disposeBag)
    }
}

// MARK: Storyboard Instantiable
extension ChangePasswordViewController: StoryboardInstantiable {
    public static func makeInstance(viewModel: ChangePasswordViewModel) -> ChangePasswordViewController {
        let viewController = ChangePasswordViewController.loadFromStoryboard(bundle: .module)
        viewController.viewModel = viewModel
        return viewController
    }
}

// MARK: Get Associated View
extension ChangePasswordViewController: ViewControllerWithAssociatedView {
    public func getAssociateView() -> ProfileMainView {
        return .changePassword
    }
}
