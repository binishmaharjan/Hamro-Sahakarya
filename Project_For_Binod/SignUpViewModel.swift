//
//  SignUpViewModel.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/11/11.
//  Copyright © 2019 JEC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum SignUpEvent {
  case signUpButtonTapped
  case backButtonTapped
  case colorViewTapped
  case statusLabelTapped
}

struct SignUpViewModel {
  
  // MARK: Properties
  private let userSessionRepository: UserSessionRepository
  private let signedInResponder: SignedInResponder
  
  let emailInput = BehaviorRelay<String>(value: "")
  let passwordInput = BehaviorRelay<String>(value: "")
  let fullNameInput = BehaviorRelay<String>(value: "")
  let initialAmountInput = BehaviorRelay<Int>(value: 0)
  let statusInput = BehaviorRelay<Status>(value: .member)
  let colorInput = BehaviorRelay<String>(value: "")
  let signUpButtonEnabled = BehaviorRelay<Bool>(value: true)

  
  @PropertyBehaviourRelay<State>(value: .idle)
  var apiState: Driver<State>
  
  private let eventSubject = PublishSubject<SignUpEvent>()
  var event: Observable<SignUpEvent> { return eventSubject.asObservable() }
  
  /// Sign Up BUtton Was Pressed``
  var signUpButtonTapped: Binder<Void> {
    return Binder(eventSubject) { observer, _ in
      observer.onNext(.signUpButtonTapped)
    }
  }
  
  var backButtonTapped: Binder<Void> {
    return Binder(eventSubject) { observer, _ in
      observer.onNext(.backButtonTapped)
    }
  }
  
  var colorViewTapped: Binder<Void> {
    return Binder(eventSubject) { observer, _ in
      observer.onNext(.colorViewTapped)
    }
  }
  
  var statusLabelTapped: Binder<Void> {
    return Binder(eventSubject) { observer, _ in
      observer.onNext(.statusLabelTapped)
    }
  }

  
  // MARK: Init
  init(userSessionRepository: UserSessionRepository, signedInResponder: SignedInResponder) {
    self.userSessionRepository = userSessionRepository
    self.signedInResponder = signedInResponder
  }
  
  
  func signUp() {
    indicateSigningUp()
    userSessionRepository.signUp(newAccount: getNewAccount())
      .done(indicateSignUpSuccessful(userSession:))
      .catch(indicateErrorSigningUp)
  }
  
  private func getNewAccount() -> NewAccount {
      let email = emailInput.value
      let password = passwordInput.value
      let fullname = fullNameInput.value
      let initialAmount = initialAmountInput.value
      let status = statusInput.value
      let color = colorInput.value
      let newAccount = NewAccount(username: fullname,
                                  email: email,
                                  status: status,
                                  colorHex: color,
                                  dateCreated: Date().toString,
                                  keyword: password,
                                  initialAmount: initialAmount)
      return newAccount
  }
}

// MARK: SignUp Indication
extension SignUpViewModel {
  private func indicateSigningUp() {
    _apiState.accept(.loading)
  }
  
  private func indicateSignUpSuccessful(userSession: UserSession) {
//    activityIndicatorAnimating.accept(false)
    _apiState.accept(.completed)
    signedInResponder.signedIn(to: userSession)
  }
  
  private func indicateErrorSigningUp(_ error: Error) {
    signUpButtonEnabled.accept(true)
    _apiState.accept(.error(error))
  }
}
