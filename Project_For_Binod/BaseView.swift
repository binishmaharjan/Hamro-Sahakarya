//
//  BaseView.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/11/16.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit

class BaseView: UIView {
  
  // MARK: Init
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    didInit()
  }
  
  convenience init() {
    self.init(frame: .zero)
    didInit()
  }
  
  // MARK: Common Init
  func didInit() { }
}


extension BaseView: HasXib {}
