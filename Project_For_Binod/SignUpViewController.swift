//
//  SignUpViewController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/11/11.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit

protocol SignUpViewModelFactory {
  func makeSignUpViewModel() -> SignUpViewModel
}

class SignUpViewController: NiblessViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.brown
  }
}
