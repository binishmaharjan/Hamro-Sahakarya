//
//  SignInViewController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/11/11.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import RxSwift

protocol SignInViewModelFactory {
  func makeSignInViewModel() -> SignInViewModel
}

class SignInViewController: NiblessViewController {
  
  // MARK: Properties
  private let viewModel: SignInViewModel
  private let disposeBag = DisposeBag()
  
  private var signInRootView: SignInRootView {
    return view as! SignInRootView
  }
  
  // MARK: Init
  init(viewModelFactory: SignInViewModelFactory) {
    self.viewModel = viewModelFactory.makeSignInViewModel()
    super.init()
  }
  
  // MARK: LifeCycle
  override func loadView() {
    view = SignInRootView.makeInstance(viewModel: viewModel)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    observeErrorMessages()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    addKeyboardObservers()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    removeObservers()
  }
  
  //MARK: Method
  func observeErrorMessages() {
    viewModel.errorMessage
      .asDriver{ _ in fatalError("Unexpected error From error messages observable") }
      .drive(onNext: { [weak self] errorMessage in
      self?.present(errorMessage: errorMessage)
      })
      .disposed(by: disposeBag)
  }

}

// MARK: Keyboard Notifications
extension SignInViewController {
  
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
    if let userInfo = notification.userInfo,
      let keyboardEndFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
      let convertedKeybaordEndFrame = view.convert(keyboardEndFrame.cgRectValue, from: view.window)
      if notification.name == UIResponder.keyboardWillHideNotification {
        signInRootView.moveContentForDismissKeyboard()
      } else {
       signInRootView.moveContent(forKeyboardFrame: convertedKeybaordEndFrame)
      }
    }
  }
  
}
