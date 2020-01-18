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
  private let sharedUserSessionRepository: UserSessionRepository
  private let sharedMainViewModel: MainViewModel
  
  let sharedSignedInViewModel: SignedInViewModel
  
  init(appDependencyContainer: AppDependencyContainer) {
    func makeSignedInViewModel() -> SignedInViewModel {
      return SignedInViewModel()
    }
    
    self.sharedUserSessionRepository = appDependencyContainer.sharedUserSessionRepository
    self.sharedMainViewModel = appDependencyContainer.sharedMainViewModel
    
    self.sharedSignedInViewModel = makeSignedInViewModel()
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
  
  func makeHomeViewController() -> HomeViewController {
    let viewController = HomeViewController()
    return viewController
  }
  
  func makeLogViewController() -> LogViewController {
    let viewController = LogViewController()
    return viewController
  }
  
  func makeProfileViewController() -> ProfileViewController {
    let viewController = ProfileViewController()
    return viewController
  }
}