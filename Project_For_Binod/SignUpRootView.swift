//
//  SignUpRootView.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/11/30.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpRootView: BaseView {
  
  // MARK: IBOutlets
  @IBOutlet private weak var emailTextField: UITextField!
  @IBOutlet private weak var fullNameTextField: UITextField!
  @IBOutlet private weak var passwordTextField: UITextField!
  @IBOutlet private weak var initialAmountTextField: UITextField!
  @IBOutlet private weak var colorView: UIView!
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet private weak var scrollViewBottomConstraints: NSLayoutConstraint!
  
  // MARK: Properties
  private var viewModel: SignUpViewModel!
  private let disposeBag = DisposeBag()
  
  // MARK: Instance
  static func makeInstane(viewModel: SignUpViewModel) -> SignUpRootView {
    let rootView = SignUpRootView.loadXib()
    rootView.viewModel = viewModel
    return rootView
  }
  
  // MARK: LifeCycle
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  // MARK: IBActions
  @IBAction func signUpButtonPressed(_ sender: Any) {
    viewModel.signUpButtonTapped.onNext(())
  }
  
  @IBAction func backButtonPressed(_ sender: Any) {
    viewModel.backButtonTapped.onNext(())
  }
  
}

// MARK: Bind
extension SignUpRootView {
  private func bind() {
    emailTextField.rx.text.asDriver()
      .map { $0 ?? "" }
      .drive(viewModel.emailInput)
      .disposed(by: disposeBag)
    
    passwordTextField.rx.text.asDriver()
      .map { $0 ?? "" }
      .drive(viewModel.passwordInput)
      .disposed(by: disposeBag)
    
    fullNameTextField.rx.text.asDriver()
      .map { $0 ?? "" }
      .drive(viewModel.fullNameInput)
      .disposed(by: disposeBag)
    
    viewModel.statusInput.asObservable()
      .map { $0.rawValue}
      .bind(to: statusLabel.rx.text)
      .disposed(by: disposeBag)
  }
}

// MARK: Keyboard 
extension SignUpRootView {
  func resetScrollViewContentInset() {
     scrollViewBottomConstraints.constant = 0
   }

   func moveContentForDismissKeyboard() {
     resetScrollViewContentInset()
   }
   
   func moveContent(forKeyboardFrame keyboardFrame: CGRect) {
     scrollViewBottomConstraints.constant = -keyboardFrame.height
   }
}
