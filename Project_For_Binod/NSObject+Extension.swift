//
//  NSObject+Extension.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/01/20.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation

extension NSObject {
  
  class var className: String {
    return String(describing: self)
  }
}
