//
//  LaunchViewModel.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/10/19.
//  Copyright © 2019 JEC. All rights reserved.
//

import Foundation
import RxSwift
import PromiseKit

struct LaunchViewModel {
  
  // MARK: Properties
  private let userSessionRepository: UserSessionRepository
  private let notSignedInReposonder: NotSignedInResponder
  private let signedInResponder: SignedInResponder
  
  var errorMessage: Observable<ErrorMessage> {
    return errorMessageSubject.asObserver()
  }
  private var errorMessageSubject: PublishSubject<ErrorMessage> = PublishSubject()
  
  let errorPresentation: BehaviorSubject<ErrorPresentation?> = BehaviorSubject(value: nil)
  
  // MARK: Init
  init(userSessionRepository: UserSessionRepository,
       notSignedInReposonder: NotSignedInResponder,
       signedInResponder: SignedInResponder) {
    self.userSessionRepository = userSessionRepository
    self.signedInResponder = signedInResponder
    self.notSignedInReposonder = notSignedInReposonder
  }
  
  // TODO: Change To Proper Error Message
  func loadUserSession() {
    userSessionRepository.readUserSession()
      .done(goToNextScreen(userProfile:))
      .catch{ error in
        let errorMessage = ErrorMessage(title: "Sign In Error",
                                        message: "Sorry, we couldn't determine if you are already signed in. Please sign in or sign up.")
        self.present(errorMessage: errorMessage)
    }
}
  
  func present(errorMessage: ErrorMessage) {
    goToNextScreenAfterErrorPresentation()
    errorMessageSubject.onNext(errorMessage)
  }
  
  func goToNextScreenAfterErrorPresentation() {
    _ = errorPresentation.filter { $0 == .dismissed }
      .take(1)
      .subscribe(onNext: { _ in
      self.goToNextScreen(userProfile: nil)
    })
  }
  
  func goToNextScreen(userProfile: UserProfile?) {
    switch userProfile {
    case .none:
      notSignedInReposonder.notSignedIn()
    case let .some(userProfile):
      signedInResponder.signedIn(to: userProfile)
    }
  }
}
