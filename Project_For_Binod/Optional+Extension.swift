//
//  Optional+Extension.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/10/19.
//  Copyright © 2019 JEC. All rights reserved.
//

import Foundation

extension Optional {

  var isEmpty: Bool {
    return self == nil
  }

  var exists:Bool {
    return self != nil
  }
}
