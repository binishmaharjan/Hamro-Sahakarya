//
//  AlertDialog.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/02/01.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit

final class AlertDialog: UIView {
  
  enum AlertType {
    case notice
    case selection
  }
  
  // MARK: IBOutlets
  @IBOutlet private weak var dailogTitle: UILabel!
  @IBOutlet private weak var alertMessageLabel: UILabel!
  @IBOutlet private weak var okButton: UIButton!
  @IBOutlet private weak var cancelButton: UIButton!
  
  // MARK: Completion Handler
  typealias CompletionHandler = () -> Void
  private var completionHandler: CompletionHandler?
  
  private func setupForAlertButton(for factory: AlertFactory) {
    dailogTitle.text = factory.title
    alertMessageLabel.text = factory.message
    
    if case .notice = factory.type {
      cancelButton.isHidden = true
    }
  }
  
  // MARK: IBAction
  @IBAction func okButtonPressed(_ sender: Any) {
    guard superview != nil else {
      return
    }
    
    UIView.animate(withDuration: 0.3,
                   animations: hideView,
                   completion: removeViewWithCompletion(isCompleted:))
  }
  
  @IBAction func cancelPressed(_ sender: Any) {
    guard superview != nil else {
      return
    }
    
    UIView.animate(withDuration: 0.3,
                   animations: hideView,
                   completion: removeView(isCompleted:))
  }
  
  // MARK: Methods
  private func hideView() {
    alpha = 0
  }
  
  private func removeView(isCompleted: Bool) {
    removeFromSuperview()
  }
  
  private func removeViewWithCompletion(isCompleted: Bool) {
    removeFromSuperview()
    completionHandler?()
  }
  
}

// MARK: Storyboard Instantiable
extension AlertDialog: HasXib {
  static func makeInstance(factory: AlertFactory, handler: CompletionHandler? = nil ) -> AlertDialog {
    let alert = AlertDialog.loadXib()
    alert.completionHandler = handler
    alert.setupForAlertButton(for: factory)
    
    return alert
  }
}


enum AlertFactory {
  case noPhotoPermission
  case logoutConfirmation
  
  var title: String {
    switch self {
      
    case .noPhotoPermission:
      return "No Permission"
    case .logoutConfirmation:
      return "Confirmation"
    }
  }
  
  var message: String {
    switch self {
      case .noPhotoPermission:
        return "You can grant access from the Settings app"
      case .logoutConfirmation:
        return "Are you sure."
    }
  }
  
  var type: AlertDialog.AlertType {
    switch self {
      
    case .noPhotoPermission:
      return .notice
    case .logoutConfirmation:
      return .selection
    }
  }
}
