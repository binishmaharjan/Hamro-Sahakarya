//
//  ProfileMainDependencyContainer.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/01/28.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation

final class ProfileMainDependencyContainer {
  // MARK: Properties
  private let sharedUserSessionRepository: UserSessionRepository
  private let sharedMainViewModel: MainViewModel
  
  private let profileMainViewModel: ProfileMainViewModel
  
  // Context
  let userSession: UserSession
  
  // MARK: Init
  init(dependencyContainer: SignedInDepedencyConatiner, userSession: UserSession) {
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
    return ProfileMainViewController(viewModel: viewModel,
                                     profileViewController: profileViewController,
                                     profileViewControllerFactory: self)
  }
  
  func makeProfileViewController() -> ProfileViewController {
    let viewModel =  makeProfileViewModel()
    let viewController = ProfileViewController.makeInstance(viewModel: viewModel)
    viewController.navigationItem.title = "Profile"
    return viewController
  }
  
  func makeProfileViewModel() -> ProfileViewModel {
    return DefaultProfileViewModel(userSession: userSession,
                                   notSignedInResponder: sharedMainViewModel,
                                   userSessionRepository: sharedUserSessionRepository,
                                   profileViewResponder: profileMainViewModel)
  }
}

// MARK: Change Profile
protocol ProfileViewControllerFactory {
  func makeChangePictureViewController() -> ChangePictureViewController
  func makeMembersViewController() -> MembersViewController
  func makeChangePasswordViewController() -> ChangePasswordViewController
  func makeChangeMemberStatusViewController() -> ChangeMemberStatusViewController
  func makeAddMonthlyFeeViewController() -> AddMonthlyFeeViewController
  func makeExtranAndExpensesViewController() -> ExtraAndExpensesViewController
    func makeLoanMemberViewController() -> LoanMemberViewController
    func makeLoanReturnedViewController() -> LoanReturnedViewController
    func makeRemoveMemberViewController() -> RemoveMemberViewController
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
  
  func makeMembersViewModel() -> MembersViewModel {
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
  
  func makeChangePasswordViewModel() -> ChangePasswordViewModel {
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
  
  func makeChangeMemberStatusViewModel() -> ChangeMemberStatusViewModel {
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
  
  func makeAddMonthlyFeeViewModel() -> AddMonthlyFeeViewModel {
    return DefaultAddMonthlyFeeViewModel(userSessionRepository: sharedUserSessionRepository,
                                         userSession: userSession)
  }
}

// MARK: Extra And Expenses ViewController
extension ProfileMainDependencyContainer {
    
    func makeExtranAndExpensesViewController() -> ExtraAndExpensesViewController {
        let viewMdel = makeExtraAndExpensesViewModel()
        let extraAndExpensesViewController = ExtraAndExpensesViewController.makeInstance(viewModel: viewMdel)
        return extraAndExpensesViewController
    }
    
    func makeExtraAndExpensesViewModel() -> ExtraAndExpensesViewModel {
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
    
    func makeLoanMemberViewModel() -> LoanMemberViewModelProtocol {
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
    
    func makeLoanRetunedViewModel() -> LoanReturnedViewModelProtocol {
        return LoanReturnedViewModel(userSessionRepository: sharedUserSessionRepository, userSession: userSession)
    }
}

// MARK: Remove Member View Controller
extension ProfileMainDependencyContainer {
    
    func makeRemoveMemberViewController() -> RemoveMemberViewController {
        return RemoveMemberViewController()
    }
    
    func makeRemoveMemberViewModel() -> RemoveMemberViewModelProtocol {
        return RemoveMemberViewModel()
    }
}
