//
//  AlertDialog.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/02/01.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit

final class AlertDialog: UIView {
  
  // MARK: IBOutlets
  @IBOutlet private weak var dailogTitle: UILabel!
  @IBOutlet private weak var alertMessageLabel: UILabel!
  @IBOutlet private weak var okButton: UIButton!
  @IBOutlet private weak var cancelButton: UIButton!
  
  // MARK: Completion Handler
  typealias CompletionHandler = () -> Void
  private var completionHandler: CompletionHandler?
  
  // MARK: IBOutlets
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
  static func makeInstance(message: String, handler: CompletionHandler? = nil ) -> AlertDialog {
    let alert = AlertDialog.loadXib()
    alert.completionHandler = handler
    alert.alertMessageLabel.text = message
    
    return alert
  }
}