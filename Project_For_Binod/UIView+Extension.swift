//
//  UIView+Extension.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/11/11.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit

extension UIView {
  
  @discardableResult
  func cornerRadius(value radius: CGFloat = 2) -> UIView {
    self.layer.cornerRadius = radius
    return self
  }
  
  @discardableResult
  func borderWidth(value width: CGFloat = 1) -> UIView {
    self.layer.borderWidth = width
    return self
  }
  
  @discardableResult
  func borderColor(color borderColor: UIColor = Colors.orange) -> UIView {
    self.layer.borderColor = borderColor.cgColor
    return self
  }
}
