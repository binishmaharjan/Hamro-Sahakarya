//
//  OnboardingRootView.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/11/11.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit

class SignInRootView: UIView {
  
  // MARK: IBOutlets
  @IBOutlet private weak var emailFieldView: UIView!
  @IBOutlet private weak var emailTextField: UITextField!
  
  @IBOutlet private weak var passwordFieldView: UIView!
  @IBOutlet private weak var passwordTextField: UITextField!
  
  @IBOutlet private weak var signInButton: UIButton!
  
  // MARK: Properties
  private var viewModel: SignInViewModel!
  
  // MARK: Instance
  static func makeInstance(viewModel: SignInViewModel) -> SignInRootView {
    let rootView = SignInRootView.loadXib()
    rootView.viewModel = viewModel
    return rootView
  }
  
  // MARK: LifeCycle
  override func awakeFromNib() {
    super.awakeFromNib()
    setupView()
  }
  
  // MARK: Methods
  private func setupView() {
    emailFieldView.borderColor().borderWidth().cornerRadius()
    passwordFieldView.borderColor().borderWidth().cornerRadius()
    signInButton.cornerRadius()
  }
  
}

extension SignInRootView: HasXib { }
