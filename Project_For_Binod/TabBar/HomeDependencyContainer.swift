//
//  HomeDependencyContainer.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/04/25.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation

final class HomeDependencyContainer {
    
    //MARK: Properties
    private let sharedUserSessionRepository: UserSessionRepository
    private let sharedMainViewModel: MainViewModel
    private let userSession: UserSession
    
    private let homeMainViewModel: HomeMainViewModel
    
    // MARK: Init
    init(dependecyContainer: SignedInDepedencyConatiner, userSession: UserSession) {
        func makeHomeMainViewModel() -> HomeMainViewModel {
            return HomeMainViewModel()
        }
        
        self.sharedUserSessionRepository = dependecyContainer.sharedUserSessionRepository
        self.sharedMainViewModel = dependecyContainer.sharedMainViewModel
        self.userSession = userSession
        
        self.homeMainViewModel = makeHomeMainViewModel()
    }
}


protocol HomeViewControllerFactory {
    
    func makeHomeViewController() -> HomeViewController
}

// MARK: Home View Controller
extension HomeDependencyContainer: HomeViewControllerFactory {
    
    func makeHomeMainViewController() -> NiblessNavigationController {
        let viewModel = homeMainViewModel
        return HomeMainViewController(viewModel: viewModel, homeViewControllerFactory: self)
    }
    
    func makeHomeViewController() -> HomeViewController {
        let viewModel = makeHomeViewModel()
        let homeViewController = HomeViewController.makeInstance(viewModel: viewModel)
        homeViewController.navigationItem.title = "Home"
        return homeViewController
    }
    
    func makeHomeViewModel() -> HomeViewModelProtocol {
        return HomeViewModel(homeViewResponder: homeMainViewModel, userSessionRepository: sharedUserSessionRepository)
    }
}
