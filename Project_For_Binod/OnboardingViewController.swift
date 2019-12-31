//
//  OnboardingViewController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/10/19.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import RxSwift

class OnboardingViewController: NiblessNavigationController {
  
  // MARK: Properties
  private let viewModel: OnboardingViewModel
  private let disposeBag = DisposeBag()
  
  // Child View Controller
  private let signInViewController: SignInViewController
  private let signUpViewController: SignUpViewController
  
  init(viewModel: OnboardingViewModel, signInViewController: SignInViewController, signUpViewController: SignUpViewController) {
    self.viewModel = viewModel
    self.signInViewController = signInViewController
    self.signUpViewController = signUpViewController
    super.init()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationSetup()
    subscribe(to: viewModel.view)
  }
  
  private func navigationSetup() {
    setNavigationBarHidden(true, animated: false)
    delegate = self
  }

  private func subscribe(to observable: Observable<OnboardingNavigationAction>) {
    observable.distinctUntilChanged()
      .subscribe(onNext: { [weak self] action in
      guard let self = self else { return }
      self.respond(to: action)
    }).disposed(by: disposeBag)
  }
}

// MARK: Presentation
extension OnboardingViewController {
  
  private func respond(to navigationAction: OnboardingNavigationAction) {
    switch navigationAction {
    case let .present(view):
      present(onboardingView: view)
    case .presented:
      break
      
    }
  }
  
  private func present(onboardingView: OnboardingView) {
    switch onboardingView {
    case .signIn:
      presentSignInView()
    case .signUp:
      presentSignUpView()
    }
  }
  
  private func presentSignInView() {
    pushViewController(signInViewController, animated: true)
  }
  
  private func presentSignUpView() {
    pushViewController(signUpViewController, animated: true)
  }
}

// MARK: UINavigationControllerDelegate
extension OnboardingViewController: UINavigationControllerDelegate {
  func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
    guard let shownView = onboardingView(assoiatedWith: viewController) else { return }
    viewModel.uiPresented(onboardingView: shownView)
  }
  
 private func onboardingView(assoiatedWith viewController: UIViewController) -> OnboardingView? {
    switch viewController {
    case is SignInViewController:
      return .signIn
    case is SignUpViewController:
      return .signUp
    default:
      fatalError("Unkwon View")
    }
  }
}
