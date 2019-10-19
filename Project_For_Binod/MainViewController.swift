//
//  MainViewController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/10/19.
//  Copyright © 2019 JEC. All rights reserved.
//

import Foundation
import RxSwift

class MainViewController: NiblessViewController {
  
  // MARK: Properties
  let disposeBag = DisposeBag()
  
  // Main View Modal
  let viewModel: MainViewModel
  
  // Child View Controllers
  let launchViewController: LaunchViewController
  var signedInViewController: SignedInViewController?
  var onboardingViewController: OnboardingViewController?
  
  //Child Factories
  typealias OnboardingFactory = () -> OnboardingViewController
  typealias SignedInFactory =  (UserProfile) -> SignedInViewController
  let makeOnboardingViewController: OnboardingFactory
  let makeSignedInViewController: SignedInFactory
  
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
    }).dispose()
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
      
    case let .signedIn(userProfile):
     presentSignedInScreen(userProfile: userProfile)
    }
  }
  
  func presentLaunchScreen() {
    addFullScreen(childViewController: launchViewController)
  }
  
  func presentOnboardingScreen() {
    let onboardingViewConroller = makeOnboardingViewController()
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

  
  func presentSignedInScreen(userProfile: UserProfile) {
    remove(childViewController: launchViewController)
    
    let signedInViewControllerToPresent: SignedInViewController
    if let viewController = self.signedInViewController {
      signedInViewControllerToPresent = viewController
    } else {
      signedInViewControllerToPresent = makeSignedInViewController(userProfile)
      signedInViewController = signedInViewControllerToPresent
    }
    
    addFullScreen(childViewController: signedInViewControllerToPresent)
    
    if onboardingViewController?.presentedViewController != nil {
      onboardingViewController = nil
      dismiss(animated: true)
    }
  }
}
