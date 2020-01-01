//
//  SignUpViewController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/11/11.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import RxSwift

protocol SignUpViewModelFactory {
  func makeSignUpViewModel() -> SignUpViewModel
}

class SignUpViewController: UIViewController {
  
  // MARK: IBOutlets
  @IBOutlet private weak var emailTextField: UITextField!
  @IBOutlet private weak var fullNameTextField: UITextField!
  @IBOutlet private weak var passwordTextField: UITextField!
  @IBOutlet private weak var statusLabel: UILabel!
  @IBOutlet private weak var colorView: UIView!
  @IBOutlet private weak var initialAmountTextField: UITextField!
  @IBOutlet private weak var signUpButton: UIButton!
  @IBOutlet private weak var scrollViewBottomConstraints: NSLayoutConstraint!
  
  // MARK: Properties
  private var viewModel: SignUpViewModel!
  private let disposeBag = DisposeBag()

  // MARK: LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    bind()
    bindEventActions()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    addKeyboardObservers()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    removeObservers()
  }
  
  // MARK: IBActions
  @IBAction private func signUpButtonPressed(_ sender: Any) {
    viewModel.signUpButtonTapped.onNext(())
  }
  
  @IBAction func backButtonPressed(_ sender: Any) {
    viewModel.backButtonTapped.onNext(())
  }
  
}

// MARK: Binding with viewModel
extension SignUpViewController {
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
  
  private func bindEventActions() {
    viewModel.event.bind { [weak self] (action) in
      guard let self = self else { return }
      
      switch action {
      case .signUpButtonTapped:
        print("Sign Up Button Tapped")
      case .backButtonPressed:
        print("Back Button Tapped")
        self.navigationController?.popViewController(animated: true)
      }
    }.disposed(by: disposeBag)
  }
}

// MARK: Storyboard Instantiable
extension SignUpViewController: StoryboardInstantiable {
  
  static func makeInstance(viewModelFactory: SignUpViewModelFactory) -> SignUpViewController {
    let viewController = loadFromStoryboard()
    viewController.viewModel = viewModelFactory.makeSignUpViewModel()
    return viewController
  }
}

// MARK: Keyboard Notification
extension SignUpViewController {
  
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

  private func removeObservers() {
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
    scrollViewBottomConstraints.constant = 0
  }
  
  private func moveContent(forKeyboardFrame keyboardFrame: CGRect) {
    scrollViewBottomConstraints.constant = -keyboardFrame.height
  }
  
}
