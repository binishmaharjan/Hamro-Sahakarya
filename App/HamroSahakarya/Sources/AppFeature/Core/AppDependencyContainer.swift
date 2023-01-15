import Core
import DataSource
import Foundation
import OnboardingFeature
import SignedInFeature

public final class AppDependencyContainer {
    // MARK: Properties
    // Long Lived Dependency
    public let sharedUserSessionRepository: UserSessionRepository
    public let sharedMainViewModel: MainViewModel
    
    // MARK: Init
    public init() {
        // User Session Repositories Dependency
        func makeUserSessionRepository() -> UserSessionRepository {
            let dataStore = makeUserDataStore()
            let serverDataManager = makeServerDataManager()
            let remoteApi = makeRemoteApi()
            let logApi = makeLogRemoteApi()
            let storageApi = makeStorageApi()
            return FirebaseUserSessionRepository(dataStore: dataStore,
                                                 remoteApi: remoteApi,
                                                 serverDataManager: serverDataManager,
                                                 logApi: logApi,
                                                 storageApi: storageApi)
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
            return FirebaseLogRemoteApi()
        }
        
        func makeServerDataManager() -> ServerDataManager {
            return FirestoreDataManager()
        }
        
        func makeStorageApi() -> StorageRemoteApi {
            return FirebaseStorageRemoteApi()
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
    public func makeMainViewController() -> MainViewController {
        let launchViewController = makeLaunchViewController()
        
        let onboardingViewControllerFactory = {
            return self.makeOnboardingViewController()
        }
        
        let signedInViewControllerFactory = { (userSession: UserSession) in
            return self.makeSignedInViewController(userSession: userSession)
        }
        
        return MainViewController(
            viewModel: sharedMainViewModel,
            launchViewController: launchViewController,
            onboardingViewControllerFactory: onboardingViewControllerFactory,
            signedInViewControllerFactory: signedInViewControllerFactory
        )
    }
}

// MARK: Launch View Controller
extension AppDependencyContainer: LaunchViewModelFactory {
    private func makeLaunchViewController() -> LaunchViewController {
        return LaunchViewController(launchViewModelFactory: self)
    }
    
    public func makeLaunchViewModel() -> LaunchViewModel {
        return LaunchViewModel(
            userSessionRepository: sharedUserSessionRepository,
            notSignedInResponder: sharedMainViewModel,
            signedInResponder: sharedMainViewModel
        )
    }
}

// MARK: Onboarding View Controller
extension AppDependencyContainer {
    private func makeOnboardingViewController() -> OnboardingViewController {
        let dependencyContainer = OnboardingDependencyContainer(appDependencyContainer: self)
        return dependencyContainer.makeOnboardingViewController()
    }
}

// MARK: SignedIn View Controller
extension AppDependencyContainer {
    private func makeSignedInViewController(userSession: UserSession) -> SignedInViewController {
        let dependencyContainer = SignedInDependencyContainer(appDependencyContainer: self, userSession: userSession)
        return dependencyContainer.makeSignedInViewController()
    }
}
