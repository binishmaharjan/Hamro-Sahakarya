//
//  OnboardingDependencyContainer.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/11/11.
//  Copyright © 2019 JEC. All rights reserved.
//

import Foundation

final class OnboardingDependencyContainer {
  
  // MARK: Properties
  
  // From Parent Container
  private let sharedUserSessionRepository: UserSessionRepository
  private let sharedMainViewModel: MainViewModel
  
  // Long Lived Dependency
  private let sharedOnboardingViewModel: OnboardingViewModel
  
  // MARK: Init
  init(appDependencyContainer: AppDependencyContainer) {
    func makeOnboardingViewModel() -> OnboardingViewModel {
      return OnboardingViewModel()
    }
    
    self.sharedMainViewModel = appDependencyContainer.sharedMainViewModel
    self.sharedUserSessionRepository = appDependencyContainer.sharedUserSessionRepository
    self.sharedOnboardingViewModel = makeOnboardingViewModel()
  }
  
}

// MARK: OnboardinViewController
extension OnboardingDependencyContainer {
  func makeOnboaardinViewController() -> OnboardingViewController {
    let signInViewController = makeSignInViewController()
    let signUpViewController = makeSignUpViewController()
    
    return OnboardingViewController(viewModel: sharedOnboardingViewModel,
                                    signInViewController: signInViewController,
                                    signUpViewController: signUpViewController)
  }
  
}

// MARK: SignInViewController
extension OnboardingDependencyContainer: SignInViewModelFactory {
  func makeSignInViewController() -> SignInViewController {
    return SignInViewController.makeInstance(viewModelFactory: self)
  }
  
  func makeSignInViewModel() -> SignInViewModel {
    return SignInViewModel(userSessionRepository: sharedUserSessionRepository,
                           signedInResponder: sharedMainViewModel,
                           signUpNavigator: sharedOnboardingViewModel)
  }
  
}

// MARK: SignUpViewController
extension OnboardingDependencyContainer: SignUpViewModelFactory, ColorPickerViewControllerFactory {
  
  func makeSignUpViewController() -> SignUpViewController {
    return SignUpViewController.makeInstance(viewModelFactory: self, colorPickerFactory: self)
  }
  
  func makeSignUpViewModel() -> SignUpViewModel {
    return SignUpViewModel(userSessionRepository: sharedUserSessionRepository,
                           signedInResponder: sharedMainViewModel)
  }
  
  func makeColorPickerViewController() -> ColorPickerViewController {
    let viewModel = makeColorPaletteViewModel()
    let colorPickerViewController = ColorPickerViewController.makeInstance(viewModel: viewModel)
    colorPickerViewController.modalPresentationStyle = .overFullScreen
    colorPickerViewController.modalTransitionStyle = .crossDissolve
    
    return colorPickerViewController
  }
  
  func makeColorPaletteViewModel() -> ColorPaletteViewModelProtocol {
    return ColorPaletteViewModel()
  }
  
}
