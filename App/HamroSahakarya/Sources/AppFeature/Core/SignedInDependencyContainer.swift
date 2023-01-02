import AppUI
import Core
import Foundation
import UIKit
import LogFeature
import SignedInFeature

internal final class SignedInDependencyContainer {
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
extension SignedInDependencyContainer {
    func makeSignedInViewController() -> SignedInViewController {
        let tabBar = makeTabBarController()
        return SignedInViewController(viewModel: sharedSignedInViewModel, tabBar: tabBar)
    }
}

// MARK: TabBar
extension SignedInDependencyContainer {
    private func makeTabBarController() -> TabBarController {
        let homeViewController = makeHomeViewController()
        let logViewController = makeLogViewController()
        let profileViewController = makeProfileViewController()
        return TabBarController(
            homeViewController: homeViewController,
            logViewController:  logViewController,
            profileViewController:  profileViewController
        )
    }
    
    private func makeHomeViewController() -> NibLessNavigationController {
        let dependencyContainer = HomeDependencyContainer(dependencyContainer: self, userSession: userSession)
        return dependencyContainer.makeHomeMainViewController()
    }
    
    private func makeLogViewController() -> NibLessNavigationController {
        let viewController = LogViewController.makeInstance(viewModel: makeLogViewModel())
        let navigationViewController = NibLessNavigationController(rootViewController: viewController)
        return navigationViewController
    }
    
    private func makeLogViewModel() -> DefaultLogViewModel {
        return DefaultLogViewModel(userSessionRepository: sharedUserSessionRepository)
    }
    
    private func makeProfileViewController() -> NibLessNavigationController {
        let dependencyContainer = ProfileMainDependencyContainer(dependencyContainer: self, userSession: userSession)
        return dependencyContainer.makeProfileMainViewController()
    }
}
