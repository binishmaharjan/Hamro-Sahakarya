//
//  SingleSelectionView.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/06/01.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit

enum SingleSelectionType: String {
  case makeAdmin = "Make Admin"
  case removeAdmin = "Remove Admin"
  case addAmount = "Add Amount"
}

class SingleSelectionView: UIView {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var navigationTitleLabel: UILabel!
  @IBOutlet weak var backButton: HSImageButtonView!
  
  @IBOutlet weak var dailougeView: UIView!
  @IBOutlet weak var dailougeTitleLabel: UILabel!
  @IBOutlet weak var dailougeAmountTextField: UITextField!
  @IBOutlet weak var cancelButton: HSTextButton!
  @IBOutlet weak var okButton: HSTextButton!
  @IBOutlet weak var selectedUserLabel: UILabel!
  
  @IBOutlet weak var dailougeTextFieldHeight: NSLayoutConstraint!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.setup()
  }
  
  private func setup() {
    backButton.image = UIImage(named: "icon_back")
    backButton.buttonMargin = .zero
  }
  
  func setupDailouge(with type: SingleSelectionType) {
    dailougeTitleLabel.text = type.rawValue
    okButton.text = "OK"
    okButton.textColor = HSColors.white
    okButton.font = HSFont.bold(size: 15)
    
    cancelButton.text = "Cancel"
    cancelButton.textColor = HSColors.white
    cancelButton.font = HSFont.bold(size: 15)
    
    switch type {
    case .makeAdmin, .removeAdmin:
      dailougeTextFieldHeight.constant = 0
    case .addAmount:
      dailougeTextFieldHeight.constant = 44
      break
    }
  }
  
  func showDialouge() {
    UIView.animate(withDuration: 0.2) { [weak self] in
      self?.dailougeView.alpha = 1
    }
  }
  
  func hideDailouge() {
    UIView.animate(withDuration: 0.2) { [weak self] in
      self?.dailougeView.alpha = 0
    }
  }
  
  func selectedUserLabel(with user: HSMemeber) {
    selectedUserLabel.text = user.username
  }
  
}

extension SingleSelectionView: HasXib {}
