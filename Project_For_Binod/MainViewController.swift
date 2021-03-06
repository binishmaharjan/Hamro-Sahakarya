//
//  MainViewController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/10/19.
//  Copyright © 2019 JEC. All rights reserved.
//

import Foundation
import RxSwift

final class MainViewController: NiblessViewController {
  
  // MARK: Properties
  private let disposeBag = DisposeBag()
  
  // Main View Modal
  let viewModel: MainViewModel
  
  // Child View Controllers
  private let launchViewController: LaunchViewController
  private var signedInViewController: SignedInViewController?
  private var onboardingViewController: OnboardingViewController?
  
  //Child Factories
  typealias OnboardingFactory = () -> OnboardingViewController
  typealias SignedInFactory =  (UserSession) -> SignedInViewController
  private let makeOnboardingViewController: OnboardingFactory
  private let makeSignedInViewController: SignedInFactory
  
  // MARK: Init
  init(viewModel: MainViewModel,
       launchViewController: LaunchViewController,
       onboardingViewControllerFactory: @escaping OnboardingFactory,
       signedInViewControllerFactory: @escaping SignedInFactory) {
    self.viewModel = viewModel
    self.launchViewController = launchViewController
    self.makeOnboardingViewController = onboardingViewControllerFactory
    self.makeSignedInViewController = signedInViewControllerFactory
    super.init()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
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

// MARK: Presentation
extension MainViewController {
  
  func present(_ view: MainView) {
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
  
  func presentLaunchScreen() {
    addFullScreen(childViewController: launchViewController)
  }
  
  func presentOnboardingScreen() {
    let onboardingViewConroller = makeOnboardingViewController()
    onboardingViewConroller.modalPresentationStyle = .fullScreen
    present(onboardingViewConroller, animated: true) { [weak self] in
      guard let self = self else { return }
      
      self.remove(childViewController: self.launchViewController)
      if let signedInViewController = self.signedInViewController {
        self.remove(childViewController: signedInViewController)
        self.signedInViewController = nil
      }
      
      self.onboardingViewController = onboardingViewConroller
    }
  }

  
  func presentSignedInScreen(userSession: UserSession) {
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
