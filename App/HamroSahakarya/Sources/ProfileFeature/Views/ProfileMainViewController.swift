import AppUI
import Core
import RxCocoa
import RxSwift
import UIKit

public protocol ViewControllerWithAssociatedView {
    func getAssociateView() -> ProfileMainView
}

public final class ProfileMainViewController: NibLessNavigationController {
    // MARK: Properties
    private let viewModel: ProfileMainViewModel
    private let disposeBag = DisposeBag()
    
    // Child View Controller Factory
    private let profileViewControllerFactory: ProfileViewControllerFactory
    
    // MARK: Init
    public init(
        viewModel: ProfileMainViewModel,
        profileViewController: ProfileViewController,
        profileViewControllerFactory: ProfileViewControllerFactory
    ) {
        self.viewModel = viewModel
        self.profileViewControllerFactory = profileViewControllerFactory
        super.init(rootViewController: profileViewController)
        
        setup()
    }
    
    // MARK: Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        subscribe(to: viewModel.view)
    }
    
    // MARK: Methods
    private func setup() {
        title = nil
        tabBarItem.image = UIImage(named: "icon_profile")?.withRenderingMode(.alwaysOriginal)
        tabBarItem.selectedImage = UIImage(named: "icon_profile_h")?.withRenderingMode(.alwaysOriginal)
        tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        delegate = self
    }
    
    private func subscribe(to observable: Observable<ProfileMainNavigationAction>) {
        observable.distinctUntilChanged()
            .subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                self.respond(to: action)
            }).disposed(by: disposeBag)
    }
    
    private func respond(to navigationAction: ProfileMainNavigationAction) {
        switch navigationAction {
        case let .present(view):
            present(profileMainView: view)
        case .presented:
            break
        }
    }
}

// MARK: Presentation
extension ProfileMainViewController {
    private func present(profileMainView: ProfileMainView) {
        switch profileMainView {
            
        case .profileView:
            break
        case .changePicture:
            showChangeProfileView()
        case .changePassword:
            showChangePasswordView()
        case .members:
            showMembersView()
        case .changeMemberStatus:
            showChangeMemberStatusView()
        case .extraAndExpenses:
            showExtraAndExpenseView()
        case .loanMember:
            showLoanMemberView()
        case .loanReturned:
            showLoanReturnedView()
        case .addOrDeductAmount:
            showAddOrDeductAmount()
        case .removeMember:
            showRemoveMemberView()
        case .termsAndCondition:
            showTermsAndConditionView()
        case .updateNotice:
            showUpdateNoticeView()
        case .license:
            break
        case .logout:
            break
        case .addMonthlyFee:
            showAddMonthlyFeeView()
        }
    }
    
    private func showChangeProfileView() {
        let viewController = profileViewControllerFactory.makeChangePictureViewController()
        pushViewController(viewController, animated: true)
    }
    
    private func showMembersView() {
        let viewController = profileViewControllerFactory.makeMembersViewController()
        pushViewController(viewController, animated: true)
    }
    
    private func showChangePasswordView() {
        let viewController = profileViewControllerFactory.makeChangePasswordViewController()
        pushViewController(viewController, animated: true)
    }
    
    private func showChangeMemberStatusView() {
        let viewController = profileViewControllerFactory.makeChangeMemberStatusViewController()
        pushViewController(viewController, animated: true)
    }
    
    private func showAddMonthlyFeeView() {
        let viewController = profileViewControllerFactory.makeAddMonthlyFeeViewController()
        pushViewController(viewController, animated: true)
    }
    
    private func showExtraAndExpenseView() {
        let viewController = profileViewControllerFactory.makeExtranAndExpensesViewController()
        pushViewController(viewController, animated: true)
    }
    
    private func showLoanMemberView() {
        let viewController = profileViewControllerFactory.makeLoanMemberViewController()
        pushViewController(viewController, animated: true)
    }
    
    private func showLoanReturnedView() {
        let viewController = profileViewControllerFactory.makeLoanReturnedViewController()
        pushViewController(viewController, animated: true)
    }
    
    private func showRemoveMemberView() {
        let viewController = profileViewControllerFactory.makeRemoveMemberViewController()
        pushViewController(viewController, animated: true)
    }
    
    private func showTermsAndConditionView() {
        let viewController = profileViewControllerFactory.makeTermsAndConditionViewController()
        pushViewController(viewController, animated: true)
    }
    
    private func showAddOrDeductAmount() {
        let viewController = profileViewControllerFactory.makeAddOrDeductAmountViewController()
        pushViewController(viewController, animated: true)
    }
    
    private func showUpdateNoticeView() {
        let viewController = profileViewControllerFactory.makeUpdateNoticeViewController()
        pushViewController(viewController, animated: true)
    }
}

// MARK: UINavigation Controller Delegate
extension ProfileMainViewController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let shownView = profileMainView(associatedWith: viewController) else {
            return
        }
        
        viewModel.uiPresented(profileView: shownView)
    }
    
    private func profileMainView(associatedWith viewController: UIViewController) -> ProfileMainView? {
        guard let viewController = viewController as? ViewControllerWithAssociatedView else {
            fatalError("ViewController does not have associated view")
        }
        
        return viewController.getAssociateView()
    }
}
