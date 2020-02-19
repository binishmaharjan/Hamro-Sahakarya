//
//  KeyboardObservingViewController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/02/19.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit

class KeyboardObservingViewController: UIViewController {
  @IBOutlet weak var scrollViewBottomContraints: NSLayoutConstraint!
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    addKeyboardObservers()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    removeKeyboardObservers()
  }
  
}

// MARK: Keyboard Notifications
extension KeyboardObservingViewController {
  
  private func addKeyboardObservers() {
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self,
                                   selector: #selector(handleContentUnderKeyboard(notification:)),
                                   name: UIResponder.keyboardWillHideNotification, object: nil)
    notificationCenter.addObserver(self,
                                   selector: #selector(handleContentUnderKeyboard(notification:)),
                                   name: UIResponder.keyboardWillChangeFrameNotification,
                                   object: nil)
  }
  
  private func removeKeyboardObservers() {
    let notificationCenter = NotificationCenter.default
    notificationCenter.removeObserver(self)
  }
  
  @objc private func handleContentUnderKeyboard(notification: Notification) {
    guard let userInfo = notification.userInfo,
      let keyboardEndFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else  { return }
    
    switch notification.name {
    case UIResponder.keyboardWillHideNotification:
      moveContentForDismissKeyboard()
    default:
      let convertedKeyboardEndFrame = view.convert(keyboardEndFrame.cgRectValue, to: view.window)
      moveContent(forKeyboardFrame: convertedKeyboardEndFrame)
    }
  }
  
  private func moveContentForDismissKeyboard() {
    scrollViewBottomContraints.constant = 0
  }
  
  private func moveContent(forKeyboardFrame keyboardFrame: CGRect) {
    scrollViewBottomContraints.constant = -keyboardFrame.height
  }
  
}
