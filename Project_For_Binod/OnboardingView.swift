//
//  OnboardingView.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/11/11.
//  Copyright © 2019 JEC. All rights reserved.
//

import Foundation

enum OnboardingView {
  
  case signIn
  case signUp
  
  var hidesNavigationBar: Bool {
    switch self {
    case .signIn:
      return false
    case .signUp:
      return false
    }
  }
}
