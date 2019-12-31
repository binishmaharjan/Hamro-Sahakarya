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

class SignUpViewController: NiblessViewController {
  
  // MARK: Properties
  private let viewModel: SignUpViewModel
  private let disposeBag = DisposeBag()
  private var signUpRootView: SignUpRootView {
    return self.view as! SignUpRootView
  }
  
  // MARK: Init
  init(viewModelFactory: SignUpViewModelFactory) {
    viewModel = viewModelFactory.makeSignUpViewModel()
    super.init()
  }
  
  // MARK: LifeCycle
  override func loadView() {
    view = SignUpRootView.makeInstane(viewModel: viewModel)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bindAction()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    addKeyboardObservers()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    removeObservers()
  }
  
  private func bindAction() {
    viewModel.event
      .subscribe(onNext: { [weak self] event in
        guard let self = self else { return }
        
        switch event {
        case .signUpButtonTapped:
          print("Sign Up Button Tapped")
        case .backButtonPressed:
          print("Back Button Tapped")
          self.navigationController?.popViewController(animated: true)
        }
      }).disposed(by: disposeBag)
  }
}

// MARK: Keyboard Notification
extension SignUpViewController {
  
  func addKeyboardObservers() {
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self,
                                   selector: #selector(handleContentUnderKeyboard(notification:)),
                                   name: UIResponder.keyboardWillHideNotification, object: nil)
    notificationCenter.addObserver(self,
                                   selector: #selector(handleContentUnderKeyboard(notification:)),
                                   name: UIResponder.keyboardWillChangeFrameNotification,
                                   object: nil)
  }

  func removeObservers() {
    let notificationCenter = NotificationCenter.default
    notificationCenter.removeObserver(self)
  }

  @objc func handleContentUnderKeyboard(notification: Notification) {

    guard let userInfo = notification.userInfo,
      let keyboardEndFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else  { return }
    
    switch notification.name {
    case UIResponder.keyboardWillHideNotification:
      signUpRootView.moveContentForDismissKeyboard()
    default:
      let convertedKeyboardEndFrame = view.convert(keyboardEndFrame.cgRectValue, to: view.window)
      signUpRootView.moveContent(forKeyboardFrame: convertedKeyboardEndFrame)
    }
  }
  
}
