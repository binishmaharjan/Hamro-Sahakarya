//
//  OnboardingViewModel.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/11/11.
//  Copyright © 2019 JEC. All rights reserved.
//

import Foundation
import RxSwift

typealias OnboardingNavigationAction = NavigationAction<OnboardingView>

class OnboardingViewModel {
  
  private let _view = BehaviorSubject<OnboardingNavigationAction>(value: .present(view: .signIn))
  var view: Observable<OnboardingNavigationAction> { return _view.asObservable() }
  
}

extension OnboardingViewModel: GoToSignUpNavigator {
  func navigateToSignUp() {
    _view.onNext(.present(view: .signUp))
  }
  
  func uiPresented(onboardingView: OnboardingView) {
    _view.onNext(.presented(view: onboardingView))
  }

}
