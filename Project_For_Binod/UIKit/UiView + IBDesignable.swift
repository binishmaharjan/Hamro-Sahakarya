//
//  UiView + IBDesignable.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/11/30.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit

@IBDesignable
extension UIView {
  
  @IBInspectable
  var borderWidth: CGFloat {
    set {
      self.layer.borderWidth = newValue
    }
    get {
      return self.borderWidth
    }
  }
  
  @IBInspectable
  var borderColor: UIColor {
    set {
      self.layer.borderColor = newValue.cgColor
    }
    get {
      return self.borderColor
    }
  }
  
  @IBInspectable
  var cornerRadius: CGFloat {
    set {
      self.layer.cornerRadius = newValue
    }
    get {
      return self.cornerRadius
    }
  }
}
