//
//  HSView.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/06/01.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit

class TextFieldView: UIView {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.layer.borderColor = HSColors.orange.cgColor
    self.layer.borderWidth = 1
    self.layer.cornerRadius = 2
  }
}
