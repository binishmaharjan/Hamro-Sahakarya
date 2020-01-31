//
//  MainViewModel.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/10/19.
//  Copyright © 2019 JEC. All rights reserved.
//

import Foundation
import RxSwift

// TODO: Make this struct
final class MainViewModel {
  
  private let viewSubject = BehaviorSubject<MainView>(value: .launching)
  var view: Observable<MainView> { return  viewSubject.asObservable() }
  
  init() { }
}

// MARK: Set Main Child View To SignedIn View
extension MainViewModel: SignedInResponder {
  
  func signedIn(to userSession: UserSession) {
    viewSubject.onNext(.signedIn(userSession: userSession))
  }
}

// MARK: Set Main Child View To Onboarding View
extension MainViewModel: NotSignedInResponder {
  
  func notSignedIn() {
    viewSubject.onNext(.onboarding)
  }
}

