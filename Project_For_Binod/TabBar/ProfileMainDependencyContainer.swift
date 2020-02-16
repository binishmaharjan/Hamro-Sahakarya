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


protocol ProfileViewControllerFactory {
  func makeChangePictureViewController() -> ChangePictureViewController
}
