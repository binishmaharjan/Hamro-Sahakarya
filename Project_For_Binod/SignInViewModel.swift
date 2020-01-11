//
//  SignInViewModel.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/11/11.
//  Copyright © 2019 JEC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum SignInEvent {
  case showRegister
  case signInTapped
}

class SignInViewModel {
  
  // MARK: Properties
  private let userSessionRepository: UserSessionRepository
  private let signedInResponder: SignedInResponder
  private let signUpNavigator: GoToSignUpNavigator
  
  var emailInput = BehaviorSubject<String>(value: "")
  var passwordInput = BehaviorSubject<String>(value: "")
  var signInButtonEnabled = BehaviorSubject<Bool>(value: true)
  var activityIndicatorAnimating = BehaviorSubject<Bool>(value: false)
  
  /// publish subject for user actions
  private let eventSubject = PublishSubject<SignInEvent>()
  var event: Observable<SignInEvent> {
    return eventSubject.asObservable()
  }
  /// user double tapped in the screen
  var doubleTapGesture: Binder<Void> {
    return Binder(eventSubject) { observer, _  in
      observer.onNext(SignInEvent.showRegister)
    }
  }
  /// User Pressed Sign in Button
  var signInButtonTapped: Binder<Void> {
    return Binder(eventSubject) { observer, _ in
      observer.onNext(SignInEvent.signInTapped)
    }
  }
  
  // GUIs
  private let dropDownSubject = PublishSubject<DropDownModel>()
  var dropDown: Observable<DropDownModel> {
    return dropDownSubject.asObserver()
  }
  
  private let errorMessageSubject = PublishSubject<ErrorMessage>()
  var errorMessage: Observable<ErrorMessage> {
    return errorMessageSubject.asObserver()
  }
  
  // MARK: Init
  init(userSessionRepository: UserSessionRepository, signedInResponder: SignedInResponder, signUpNavigator: GoToSignUpNavigator) {
    self.userSessionRepository = userSessionRepository
    self.signedInResponder = signedInResponder
    self.signUpNavigator = signUpNavigator
  }
  
  // MARK: Methods
  
  /// Sign in with current email and password
  ///
  /// Returns: Void
  func signIn() {
    indicateSigingIn()
    let (email, password) = getEmailAndPassword()
    userSessionRepository.signIn(email: email, password: password)
      .done(signedInResponder.signedIn(to:))
      .catch(indicateErrorSigningIn)
  }
  
  /// Navigate To Sign Up View
  ///
  /// Returns: Void
  func showSignUpView() {
    signUpNavigator.navigateToSignUp()
  }
  
  private func getEmailAndPassword() -> (String, String) {
    do {
      return try (emailInput.value(), passwordInput.value())
    } catch {
      fatalError("Error Reading Text Field Values")
    }
  }
  
  private func indicateSigingIn() {
    signInButtonEnabled.onNext(false)
    activityIndicatorAnimating.onNext(true)
  }
  
  private func indicateErrorSigningIn(_ error: Error) {
    let errorMessage = ErrorMessage(title: "Sign In Failed.", message: error.localizedDescription)
    errorMessageSubject.onNext(errorMessage)
    
    signInButtonEnabled.onNext(true)
    activityIndicatorAnimating.onNext(false)
    
    dropDownSubject.onNext(DropDownModel(dropDownType: .error, message: errorMessage.message))
  }
  
}

