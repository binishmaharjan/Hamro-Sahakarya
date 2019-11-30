//
//  DropDownType.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/11/16.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit

enum DropDownType {
  case error
  case success
  case normal
  
  
  var backroundColor: UIColor {
    switch self {
    case .error:
      return .red_50
    case .success:
      return .green_50
    case .normal:
      return .mainBlack_50
    }
  }
}
