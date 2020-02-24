//
//  MainOrangeButton.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/02/24.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit

final class MainOrangeButton: UIButton {
  override var isEnabled: Bool {
    didSet {
      backgroundColor = self.isEnabled ? .mainOrange : .mainOrange_70
    }
  }
}
