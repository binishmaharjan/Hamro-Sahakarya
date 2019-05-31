//
//  ChangePasswordView.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/05/31.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit

class ChangePasswordView: UIView {
  
  @IBOutlet weak var newPasswordField: UITextField!
  @IBOutlet weak var changePasswordButton: HSTextButton!
  @IBOutlet weak var backButton: HSImageButtonView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.setup()
  }
  
  private func setup() {
    changePasswordButton.text = "Change"
    changePasswordButton.textColor = HSColors.white
    changePasswordButton.font = HSFont.bold(size: 14)
    changePasswordButton.layer.cornerRadius = 2
    
    backButton.image = UIImage(named: "icon_back")
    backButton.buttonMargin = .zero
    
    newPasswordField.delegate = self
  }
  
}

extension ChangePasswordView: HasXib {}

extension ChangePasswordView: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
}
