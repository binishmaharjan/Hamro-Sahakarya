import Core
import Foundation
import ProfileFeature

internal final class ProfileMainDependencyContainer {
    // MARK: Properties
    private let sharedUserSessionRepository: UserSessionRepository
    private let sharedMainViewModel: MainViewModel
    
    private let profileMainViewModel: ProfileMainViewModel
    
    // Context
    let userSession: UserSession
    
    // MARK: Init
    init(
        dependencyContainer: SignedInDependencyContainer,
        userSession: UserSession
    ) {
        func makeProfileMainViewModel() -> ProfileMainViewModel {
            return DefaultProfileMainViewModel()
        }
        
        self.sharedMainViewModel = dependencyContainer.sharedMainViewModel
        self.sharedUserSessionRepository = dependencyContainer.sharedUserSessionRepository
        
        self.profileMainViewModel = makeProfileMainViewModel()
        self.userSession = userSession
    }
}

// MARK: Profile Main View Controller
extension ProfileMainDependencyContainer {
    func makeProfileMainViewController() -> ProfileMainViewController {
        let viewModel = profileMainViewModel
        let profileViewController = makeProfileViewController()
        return ProfileMainViewController(
            viewModel: viewModel,
            profileViewController: profileViewController,
            profileViewControllerFactory: self
        )
    }
    
    private func makeProfileViewController() -> ProfileViewController {
        let viewModel =  makeProfileViewModel()
        let viewController = ProfileViewController.makeInstance(viewModel: viewModel)
        viewController.navigationItem.title = "Profile"
        return viewController
    }
    
    private func makeProfileViewModel() -> ProfileViewModel {
        return DefaultProfileViewModel(
            userSession: userSession,
            notSignedInResponder: sharedMainViewModel,
            userSessionRepository: sharedUserSessionRepository,
            profileViewResponder: profileMainViewModel
        )
    }
}

extension ProfileMainDependencyContainer: ProfileViewControllerFactory {
    func makeChangePictureViewController() -> ChangePictureViewController {
        let viewModel = makeChangePictureViewModel()
        let changePictureViewController = ChangePictureViewController.makeInstance(viewModel: viewModel)
        return changePictureViewController
    }
    
    func makeChangePictureViewModel() -> ChangePictureViewModel {
        return DefaultChangePictureViewModel(userSession: userSession, userSessionRepository: sharedUserSessionRepository)
    }
}

// MARK: Members
extension ProfileMainDependencyContainer {
    func makeMembersViewController() -> MembersViewController {
        let viewModel = makeMembersViewModel()
        let membersViewController = MembersViewController.makeInstance(viewModel: viewModel)
        return membersViewController
    }
    
    private func makeMembersViewModel() -> MembersViewModel {
        return DefaultMembersViewModel(userSessionRepository: sharedUserSessionRepository)
    }
}

// MARK: Change Password
extension ProfileMainDependencyContainer {
    func makeChangePasswordViewController() -> ChangePasswordViewController {
        let viewModel = makeChangePasswordViewModel()
        let changeViewController = ChangePasswordViewController.makeInstance(viewModel: viewModel)
        return changeViewController
    }
    
    private func makeChangePasswordViewModel() -> ChangePasswordViewModel {
        return DefaultChangePasswordViewModel(userSessionRepository: sharedUserSessionRepository, userSession: userSession, notSignedInResponder: sharedMainViewModel)
    }
}

// MARK: Change Member Status
extension ProfileMainDependencyContainer {
    func makeChangeMemberStatusViewController() -> ChangeMemberStatusViewController {
        let viewModel = makeChangeMemberStatusViewModel()
        let changeMemberStatusViewController = ChangeMemberStatusViewController.makeInstance(viewModel: viewModel)
        return changeMemberStatusViewController
    }
    
    private func makeChangeMemberStatusViewModel() -> ChangeMemberStatusViewModel {
        return DefaultChangeMemberStatusViewModel(userSessionRepository: sharedUserSessionRepository,
                                                  userSession: userSession)
    }
}

// MARK: AddMonthlyFeeViewController
extension ProfileMainDependencyContainer {
    func makeAddMonthlyFeeViewController() -> AddMonthlyFeeViewController {
        let viewModel = makeAddMonthlyFeeViewModel()
        let addMonthlyFeeViewController = AddMonthlyFeeViewController.makeInstance(viewModel: viewModel)
        return addMonthlyFeeViewController
    }
    
    private func makeAddMonthlyFeeViewModel() -> AddMonthlyFeeViewModel {
        return DefaultAddMonthlyFeeViewModel(userSessionRepository: sharedUserSessionRepository,
                                             userSession: userSession)
    }
}

// MARK: Extra And Expenses ViewController
extension ProfileMainDependencyContainer {
    func makeExtranAndExpensesViewController() -> ExtraAndExpensesViewController {
        let viewModel = makeExtraAndExpensesViewModel()
        let extraAndExpensesViewController = ExtraAndExpensesViewController.makeInstance(viewModel: viewModel)
        return extraAndExpensesViewController
    }
    
    private func makeExtraAndExpensesViewModel() -> ExtraAndExpensesViewModel {
        return ExtraAndExpensesViewModel(userSessionRepository: sharedUserSessionRepository, userSession:  userSession)
    }
}

// MARK: Loan Member ViewController
extension ProfileMainDependencyContainer {
    func makeLoanMemberViewController() -> LoanMemberViewController {
        let viewModel = makeLoanMemberViewModel()
        let loanMemberViewController = LoanMemberViewController.makeInstance(viewModel: viewModel)
        return loanMemberViewController
    }
    
    private func makeLoanMemberViewModel() -> LoanMemberViewModelProtocol {
        return LoanMemberViewModel(userSessionRepository: sharedUserSessionRepository, userSession: userSession)
    }
}

// MARK: Loan Returned View Controller
extension ProfileMainDependencyContainer {
    func makeLoanReturnedViewController() -> LoanReturnedViewController {
        let viewModel = makeLoanRetunedViewModel()
        let loanReturnedViewController = LoanReturnedViewController.makeInstance(viewModel: viewModel)
        return loanReturnedViewController
    }
    
    private func makeLoanRetunedViewModel() -> LoanReturnedViewModelProtocol {
        return LoanReturnedViewModel(userSessionRepository: sharedUserSessionRepository, userSession: userSession)
    }
}

// MARK: Remove Member View Controller
extension ProfileMainDependencyContainer {
    func makeRemoveMemberViewController() -> RemoveMemberViewController {
        let viewModel = makeRemoveMemberViewModel()
        let removeMemberViewController = RemoveMemberViewController.makeInstance(viewModel: viewModel)
        return removeMemberViewController
    }
    
    private func makeRemoveMemberViewModel() -> RemoveMemberViewModelProtocol {
        return RemoveMemberViewModel(userSessionRepository: sharedUserSessionRepository, userSession: userSession)
    }
}

// MARK: Terms And Condition View Controller
extension ProfileMainDependencyContainer {
    func makeTermsAndConditionViewController() -> TermsAndConditionViewController {
        let viewModel = makeTermsAndConditionViewModel()
        let viewController = TermsAndConditionViewController.makeInstance(viewModel: viewModel)
        return viewController
    }
    
    private func makeTermsAndConditionViewModel() -> TermsAndConditionViewModelProtocol {
        return TermsAndConditionViewModel(userSessionRepository: sharedUserSessionRepository)
    }
}

// MARK: Add or Deduct View Controller
extension ProfileMainDependencyContainer {
    func makeAddOrDeductAmountViewController() -> AddOrDeductAmountViewController {
        let viewModel = makeAddOrDeductAmountViewModel()
        let viewController = AddOrDeductAmountViewController.makeInstance(viewModel: viewModel)
        return viewController
    }
    
    private func makeAddOrDeductAmountViewModel() -> AddOrDeductAmountViewModelProtocol {
        return AddOrDeductAmountViewModel(userSessionRepository: sharedUserSessionRepository, userSession: userSession)
    }
}

// MARK: Update Notice View Controller
extension ProfileMainDependencyContainer {
    func makeUpdateNoticeViewController() -> UpdateNoticeViewController {
        let viewModel = makeUpdateNoticeViewModel()
        let viewController = UpdateNoticeViewController.makeInstance(viewModel: viewModel)
        return viewController
    }
    
    private func makeUpdateNoticeViewModel() -> UpdateNoticeViewModelProtocol {
        return UpdateNoticeViewModel(userSessionRepository: sharedUserSessionRepository, userSession: userSession)
    }
}
