//
//  HSNavigationController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/04/06.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit


class HSNavigationController:UINavigationController{
  
  //MARK:Init
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationBar.barTintColor = HSColors.white
    self.navigationBar.tintColor = HSColors.black
    let attrs = [
      NSAttributedString.Key.foregroundColor : HSColors.orange
    ]
    self.navigationBar.titleTextAttributes = attrs
    self.navigationBar.isTranslucent = false
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle{
    return .default
  }
}
