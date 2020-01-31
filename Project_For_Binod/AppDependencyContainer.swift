//
//  AppDependencyContainer.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/10/19.
//  Copyright © 2019 JEC. All rights reserved.
//

import Foundation

final class AppDependencyContainer {
  
  // MARK: Properties
  // Long Lived Dependency
  let sharedUserSessionRepository: UserSessionRepository
  let sharedMainViewModel: MainViewModel
  
  // MARK: Init
  init() {
    
    // User Session Repositories Dependency
    func makeUserSessionRepository() -> UserSessionRepository {
      let dataStore = makeUserDataStore()
      let serverDataManager = makeServerDataManager()
      let remoteApi = makeRemoteApi()
      let logApi = makeLogRemoteApi()
      return FirebaseUserSessionRepository(dataStore: dataStore,
                                           remoteApi: remoteApi,
                                           serverDataManager: serverDataManager,
                                           logApi: logApi)
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
    
    func makeLogRemoteApi() -> LogRemoteApi {
      return FireBaseLogRemoteApi()
    }
    
    func makeServerDataManager() -> ServerDataManager {
      return FireStoreDataManager()
    }
    
    // Main View Model Dependency
    func makeMainViewModel() -> MainViewModel {
      return MainViewModel()
    }
    
    // Initialization
    self.sharedUserSessionRepository = makeUserSessionRepository()
    self.sharedMainViewModel = makeMainViewModel()
    
  }
}

// MARK: Main View Controller
extension AppDependencyContainer {

  func makeMainViewController() -> MainViewController {
    let launchViewController = makeLaunchViewController()
    
    let onboardingViewControllerFactory = {
      return self.makeOnboardingViewController()
    }
    
    let signedInViewControllerFactory = { (userSession: UserSession) in
      return self.makeSignedInViewController(userSession: userSession)
    }
    
    return MainViewController(viewModel: sharedMainViewModel,
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
    return LaunchViewModel(userSessionRepository: sharedUserSessionRepository,
                           notSignedInReposonder: sharedMainViewModel,
                           signedInResponder: sharedMainViewModel)
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
  
  func makeSignedInViewController(userSession: UserSession) -> SignedInViewController {
    let dependencyContainer = SignedInDepedencyConatiner(appDependencyContainer: self, userSession: userSession)
    return dependencyContainer.makeSignedInViewController()
  }
}
