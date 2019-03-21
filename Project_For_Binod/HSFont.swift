//
//  HSFont.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/03/22.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit


class HSFont{
  static func normal(size:CGFloat, weight:UIFont.Weight=UIFont.Weight.regular)->UIFont{
    return UIFont.systemFont(ofSize: size)
  }
  
  static func bold(size:CGFloat)->UIFont{
    return UIFont.boldSystemFont(ofSize:size)
  }
  
  static func heavy(size:CGFloat)->UIFont{
    return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.heavy)
  }
}
