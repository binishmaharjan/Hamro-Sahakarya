//
//  OnboardingRootView.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/11/11.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class SignInRootView: BaseView {
  
  // MARK: IBOutlets
  @IBOutlet private weak var emailFieldView: UIView!
  @IBOutlet private weak var emailTextField: UITextField!
  
  @IBOutlet private weak var passwordFieldView: UIView!
  @IBOutlet private weak var passwordTextField: UITextField!
  
  @IBOutlet private weak var signInButton: UIButton!
  @IBOutlet weak var scrollViewBottomContraints: NSLayoutConstraint!
  
  // MARK: Properties
  private var viewModel: SignInViewModel!
  private let disposeBag = DisposeBag()
  
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
  
  override func didMoveToWindow() {
    super.didMoveToWindow()
    bindViews()
  }
  
  // MARK: Methods
  private func setupView() {
    emailFieldView.apply(types: [.borderColor(.mainOrange), .borderWidth(1),.cornerRadius(2)])
    passwordFieldView.apply(types: [.borderColor(.mainOrange), .borderWidth(1),.cornerRadius(2)])
    signInButton.apply(types: [.cornerRadius(2)])
  }
}

// MARK: Bind
extension SignInRootView {
  
  private func bindViews() {
    emailTextField.rx.text.asDriver()
      .map { $0 ?? "" }
      .drive(viewModel.emailInput)
      .disposed(by: disposeBag)
    
    passwordTextField.rx.text.asDriver()
      .map { $0 ?? "" }
      .drive(viewModel
        .passwordInput)
      .disposed(by: disposeBag)
    
    signInButton.rx.tap.asDriver()
      .drive(onNext:{ [weak self] _ in
        self?.viewModel.signIn()
      })
      .disposed(by: disposeBag)

    viewModel.activityIndicatorAnimating
      .asDriver(onErrorJustReturn: false)
      .drive(GUIManager.rx.isIndicatorAnimating())
      .disposed(by: disposeBag)
    
    viewModel.dropDown
      .asDriver(onErrorJustReturn: DropDownModel.defaultDropDown)
      .drive(GUIManager.rx.shouldShowDropDown())
      .disposed(by: disposeBag)
    
    viewModel.signInButtonEnabled
      .asDriver(onErrorJustReturn: true)
      .drive(signInButton.rx.isEnabled)
      .disposed(by: disposeBag)
    
    self.rx.tapGesture{ gesture, _ in
      gesture.numberOfTouchesRequired = 2
      gesture.numberOfTapsRequired = 2
    }
    .bind(to: viewModel.doubleTapGesture)
    .disposed(by: disposeBag)
    
    viewModel.tapAction.bind { (action) in
      switch action{
      case .showRegister:
        print("Show Register View")
      }
    }.disposed(by: disposeBag)
  }
}

// MARK: Keyboard
extension SignInRootView {

  func resetScrollViewContentInset() {
    scrollViewBottomContraints.constant = 0
  }

  func moveContentForDismissKeyboard() {
    resetScrollViewContentInset()
  }
  
  func moveContent(forKeyboardFrame keyboardFrame: CGRect) {
    scrollViewBottomContraints.constant = -keyboardFrame.height
  }
}

