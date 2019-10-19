//
//  MainViewModel.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/10/19.
//  Copyright © 2019 JEC. All rights reserved.
//

import Foundation
import RxSwift

class MainViewModel {
  
  private let viewSubject = BehaviorSubject<MainView>(value: .launching)
  var view: Observable<MainView> { return  viewSubject.asObservable() }
  
  init() { }
}

// MARK: Set Main Child View To SignedIn View
extension MainViewModel: SignedInResponder {
  
  func signedIn(to userProfile: UserProfile) {
    viewSubject.onNext(.signedIn(userProfile: userProfile))
  }
}

// MARK: Set Main Child View To Onboarding View
extension MainViewModel: NotSignedInResponder {
  
  func notSignedIn() {
    viewSubject.onNext(.onboarding)
  }
}

