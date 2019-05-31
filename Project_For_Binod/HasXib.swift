//
//  HasXib.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/05/31.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit

protocol HasXib {}

extension HasXib {
  static var xibName: String {
    return String(describing: Self.self)
  }
}

extension HasXib where Self: UIView {
  static func loadXib() -> Self {
    return UINib(nibName: xibName, bundle: nil).instantiate(withOwner: self, options: nil).first as! Self
  }
}

extension HasXib where Self: UITableViewCell {
  static func loadNib() -> UINib {
    return UINib(nibName: xibName, bundle: nil)
  }
}
