//
//  HasXib.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/10/19.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit

protocol HasXib { }

extension HasXib where Self: UIView{
  static var xibName: String {
    return String(describing: Self.self)
  }
  
  static func loadXib() -> Self {
    let nib = UINib(nibName: xibName, bundle: nil)
    let view = nib.instantiate(withOwner: self, options: nil).first as! Self
    return view
  }
}
