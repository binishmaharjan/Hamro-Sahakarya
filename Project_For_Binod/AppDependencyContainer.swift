//
//  AppDependencyContainer.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/10/19.
//  Copyright © 2019 JEC. All rights reserved.
//

import Foundation

class AppDependencyContainer {
  
  // MARK: Properties
  
  // Long Lived Dependency
  private let _sharedUserSessionRepository: UserSessionRepository
  var sharedUserSessionRepository: UserSessionRepository {
    return _sharedUserSessionRepository
  }
  
  private let _sharedMainViewModel: MainViewModel
  var sharedMainViewModel: MainViewModel {
    return _sharedMainViewModel
  }
  
  // MARK: Init
  init() {
    
    // User Session Repositories Dependency
    func makeUserSessionRepository() -> UserSessionRepository {
      let dataStore = makeUserDataStore()
      let serverDataManager = makeServerDataManager()
      let remoteApi = makeRemoteApi()
      return FirebaseUserSessionRepository(dataStore: dataStore,
                                           remoteApi: remoteApi,
                                           serverDataManager: serverDataManager)
    }
    
    func makeUserDataStore() -> UserDataStore {
      let coder = makeUserProfileCoder()
      return UserDefaultsDataStore(userProfileCoder: coder)
    }
    
    func makeUserProfileCoder() -> UserProfileCoding {
      return UserProfilePropertyListCoder()
    }
    
    func makeRemoteApi() -> AuthRemoteApi {
      return FirebaseAuthRemoteApi()
    }
    
    func makeServerDataManager() -> ServerDataManager {
      return FireStoreDataManager()
    }
    
    // Main View Model Dependency
    func makeMainViewModel() -> MainViewModel {
      return MainViewModel()
    }
    
    // Initialization
    self._sharedUserSessionRepository = makeUserSessionRepository()
    self._sharedMainViewModel = makeMainViewModel()
    
  }
}

// MARK: Main View Controller
extension AppDependencyContainer {

  func makeMainViewController() -> MainViewController {
    let launchViewController = makeLaunchViewController()
    
    let onboardingViewControllerFactory = {
      return self.makeOnboardingViewController()
    }
    
    let signedInViewControllerFactory = { (userProfile: UserProfile) in
      return self.makeSignedInViewController(profile: userProfile)
    }
    
    return MainViewController(viewModel: _sharedMainViewModel,
                              launchViewController: launchViewController,
                              onboardingViewControllerFactory: onboardingViewControllerFactory,
                              signedInViewControllerFactory: signedInViewControllerFactory)
  }
}

// MARK: Launch View Controller
extension AppDependencyContainer: LaunchViewModelFactory {
  
  func makeLaunchViewController() -> LaunchViewController {
    return LaunchViewController(launchViewModelFactory: self)
  }
  
  func makeLaunchViewModel() -> LaunchViewModel {
    return LaunchViewModel(userSessionRepository: _sharedUserSessionRepository,
                           notSignedInReposonder: _sharedMainViewModel,
                           signedInResponder: _sharedMainViewModel)
  }
}

// MARK: Onboarding View Controller
extension AppDependencyContainer {
  
  func makeOnboardingViewController() -> OnboardingViewController {
    let dependencyContaienr = OnboardingDependencyContainer(appDependencyContainer: self)
    return dependencyContaienr.makeOnboaardinViewController()
  }
}

// MARK: SignedIn View Controller
extension AppDependencyContainer {
  
  func makeSignedInViewController(profile: UserProfile) -> SignedInViewController {
    return SignedInViewController()
  }
}
