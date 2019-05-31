//
//  ChangePasswordViewController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/05/31.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit

class ChangePasswordViewController: HSViewController {
  
  let changePasswordView = ChangePasswordView.loadXib()
  
  override func loadView() {
    self.view = changePasswordView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupChangePasswordView()
  }
  
  private func setupChangePasswordView() {
    changePasswordView.backButton.delegate = self
    changePasswordView.changePasswordButton.delegate = self
  }
  
}

extension ChangePasswordViewController: HSButtonViewDelegate {
  func buttonViewTapped(view: HSButtonView) {
    if view == changePasswordView.backButton {
      self.navigationController?.popViewController(animated: true)
    } else if view == changePasswordView.changePasswordButton {
      guard let newPassword = changePasswordView.newPasswordField.text else {
        return
      }
      self.changePassword(newPassword: newPassword)
      changePasswordView.newPasswordField.resignFirstResponder()
    }
  }
}

extension ChangePasswordViewController: HSUserDatabase, HSUserLogin {
  
  private func changePassword(newPassword: String) {
    HSActivityIndicator.shared.start(view: self.view)
    self.changeFirebasePassword(newPassword: newPassword) { (error) in
      if let error = error {
        createDropDownAlert(message: error.localizedDescription, type: .error)
        HSActivityIndicator.shared.stop()
        return
      }
      
      self.updateKeyword(keyword: newPassword, completion: { [weak self] (error) in
        if let error = error {
          createDropDownAlert(message: error.localizedDescription, type: .error)
          HSActivityIndicator.shared.stop()
          return
        }
        
        //Successful
        HSActivityIndicator.shared.stop()
        createDropDownAlert(message: "Successful", type: .success)
        self?.changePasswordView.newPasswordField.text = ""
      })
    }
  }
}
