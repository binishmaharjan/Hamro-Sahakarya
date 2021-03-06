//
//  SignedInDependencyContainer.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/01/18.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation

final class SignedInDepedencyConatiner {
  
  // MARK: Properties
  let sharedUserSessionRepository: UserSessionRepository
  let sharedMainViewModel: MainViewModel
  
  let sharedSignedInViewModel: SignedInViewModel
  
  // Context
  let userSession: UserSession
  
  init(appDependencyContainer: AppDependencyContainer, userSession: UserSession) {
    func makeSignedInViewModel() -> SignedInViewModel {
      return SignedInViewModel()
    }
    
    self.sharedUserSessionRepository = appDependencyContainer.sharedUserSessionRepository
    self.sharedMainViewModel = appDependencyContainer.sharedMainViewModel
    
    self.sharedSignedInViewModel = makeSignedInViewModel()
    self.userSession = userSession
  }
}

// MARK: SignedInViewContainer
extension SignedInDepedencyConatiner {

  func makeSignedInViewController() -> SignedInViewController {
    let tabBar = makeTabBarController()
    return SignedInViewController(viewModel: sharedSignedInViewModel, tabBar: tabBar)
  }
}

// MARK: TabBar
import UIKit

extension SignedInDepedencyConatiner {
  
  func makeTabBarController() -> TabBarController {
    let homeViewController = makeHomeViewController()
    let logViewController = makeLogViewController()
    let profileViewController = makeProfileViewController()
    return TabBarController(homeViewController: homeViewController,
                            logViewController:  logViewController,
                            profileViewController:  profileViewController)
  }
  
  func makeHomeViewController() -> UINavigationController {
    let dependencyContainer = HomeDependencyContainer(dependecyContainer: self, userSession: userSession)
    return dependencyContainer.makeHomeMainViewController()
  }
  
  func makeLogViewController() -> UINavigationController {
    let viewController = LogViewController.makeInstance(viewModel: makeLogViewModel())
    let navigationViewController = NiblessNavigationController(rootViewController: viewController)
    return navigationViewController
  }
  
  func makeLogViewModel() -> DefaultLogViewModel {
    return DefaultLogViewModel(userSessionRepository: sharedUserSessionRepository)
  }
  
  func makeProfileViewController() -> ProfileMainViewController {
    let dependencyContainer = ProfileMainDependencyContainer(dependencyContainer: self, userSession: userSession)
    return dependencyContainer.makeProfileMainViewController()
  }
}
