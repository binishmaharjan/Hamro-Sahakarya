//
//  MainView.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/10/19.
//  Copyright © 2019 JEC. All rights reserved.
//

import Foundation

enum MainView {
  
  case launching
  case onboarding
  case signedIn(userProfile: UserProfile)
}

extension MainView: Equatable {

  static func ==(lhs: MainView, rhs: MainView) -> Bool {
    switch (lhs, rhs) {
    case (.launching, .launching):
      return true
      case (.onboarding, .onboarding):
      return true
    case let (.signedIn(l), .signedIn(r)):
      return l == r
    default:
      return false
    }
  }
}
