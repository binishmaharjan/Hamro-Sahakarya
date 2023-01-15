import AppUI
import Core
import Foundation
import RxSwift
import OnboardingFeature
import SignedInFeature

public final class MainViewController: NibLessViewController {
    // MARK: Properties
    private let disposeBag = DisposeBag()
    
    // Main View Modal
    public let viewModel: MainViewModel
    
    // Child View Controllers
    private let launchViewController: LaunchViewController
    private var signedInViewController: SignedInViewController?
    private var onboardingViewController: OnboardingViewController?
    
    // Child Factories
    public typealias OnboardingFactory = () -> OnboardingViewController
    public typealias SignedInFactory =  (UserSession) -> SignedInViewController
    private let makeOnboardingViewController: OnboardingFactory
    private let makeSignedInViewController: SignedInFactory
    
    // MARK: Init
    public init(
        viewModel: MainViewModel,
        launchViewController: LaunchViewController,
        onboardingViewControllerFactory: @escaping OnboardingFactory,
        signedInViewControllerFactory: @escaping SignedInFactory
    ) {
        self.viewModel = viewModel
        self.launchViewController = launchViewController
        self.makeOnboardingViewController = onboardingViewControllerFactory
        self.makeSignedInViewController = signedInViewControllerFactory
        super.init()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        observeVieModal()
    }
    
    // MARK: Methods
    private func observeVieModal() {
        let observable = viewModel.view.distinctUntilChanged()
        subscribe(to: observable)
    }
    
    func subscribe(to observable: Observable<MainView>) {
        observable.subscribe(onNext: { [weak self] view in
            guard let self = self else { return }
            self.present(view)
        }).disposed(by: disposeBag)
    }
}

// MARK: Setup
extension MainViewController {
    private func setup() {
        view.backgroundColor = .white
        // Calling present with launching because there is some time interval when view is presented
        present(.launching)
    }
}

// MARK: Presentation
extension MainViewController {
    public func present(_ view: MainView) {
        switch view {
        case .launching:
            presentLaunchScreen()
            
        case . onboarding:
            guard onboardingViewController?.presentedViewController == nil else { return }
            
            if presentedViewController.exists {
                // Dismis profile modal view when signing out
                dismiss(animated: true) { [weak self] in
                    self?.presentOnboardingScreen()
                }
            } else {
                presentOnboardingScreen()
            }
            
        case let .signedIn(userSession):
            presentSignedInScreen(userSession: userSession)
        }
    }
    
    public func presentLaunchScreen() {
        addFullScreen(childViewController: launchViewController)
    }
    
    public func presentOnboardingScreen() {
        let onboardingViewController = makeOnboardingViewController()
        onboardingViewController.modalPresentationStyle = .fullScreen
        present(onboardingViewController, animated: true) { [weak self] in
            guard let self = self else { return }
            
            self.remove(childViewController: self.launchViewController)
            if let signedInViewController = self.signedInViewController {
                self.remove(childViewController: signedInViewController)
                self.signedInViewController = nil
            }
            
            self.onboardingViewController = onboardingViewController
        }
    }

    public func presentSignedInScreen(userSession: UserSession) {
        remove(childViewController: launchViewController)
        
        let signedInViewControllerToPresent: SignedInViewController
        if let viewController = self.signedInViewController {
            signedInViewControllerToPresent = viewController
        } else {
            signedInViewControllerToPresent = makeSignedInViewController(userSession)
            signedInViewController = signedInViewControllerToPresent
        }
        
        addFullScreen(childViewController: signedInViewControllerToPresent)
        
        if onboardingViewController?.presentingViewController != nil {
            onboardingViewController = nil
            dismiss(animated: true)
        }
    }
}
