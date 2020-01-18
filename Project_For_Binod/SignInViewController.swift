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

class SignInViewController: UIViewController {

  // MARK: IBOutlet
  @IBOutlet private weak var scrollViewBottomContraints: NSLayoutConstraint!
  @IBOutlet private weak var emailTextField: UITextField!
  @IBOutlet private weak var passwordTextField: UITextField!
  @IBOutlet private weak var signInButton: UIButton!
  
  // MARK: Properties
  private var viewModel: SignInViewModel!
  private let disposeBag = DisposeBag()
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    bind()
    bindActionEvents()
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
      .drive(onNext: { errorMessage in
        //      self?.present(errorMessage: errorMessage)
        Dlog("Error Message: \(errorMessage.message)")
      })
      .disposed(by: disposeBag)
  }
  
  private func setup() {
    // Double Finger Tap Gesture
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleFingerDoubleTapped))
    tapGesture.numberOfTouchesRequired = 2
    tapGesture.numberOfTapsRequired = 2
    view.addGestureRecognizer(tapGesture)
  }
  
  @objc private func doubleFingerDoubleTapped() {
    viewModel.doubleTapGesture.onNext(())
  }
  
  // MARK: IBActions
  @IBAction private func signInButtonPressed(_ sender: Any) {
    viewModel.signInButtonTapped.onNext(())
  }
}

// MARK: Storyboard Instantiable
extension SignInViewController: StoryboardInstantiable {
  
  static func makeInstance(viewModelFactory: SignInViewModelFactory) -> SignInViewController {
    let viewcontroller = loadFromStoryboard()
    viewcontroller.viewModel = viewModelFactory.makeSignInViewModel()
    return viewcontroller
  }
}

// MARK: Binding With ViewModel
extension SignInViewController {
  
  private func bind() {
    emailTextField.rx.text.asDriver()
      .map { $0 ?? "" }
      .drive(viewModel.emailInput)
      .disposed(by: disposeBag)
    
    passwordTextField.rx.text.asDriver()
      .map { $0 ?? "" }
      .drive(viewModel
        .passwordInput)
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
  }
  
  private func bindActionEvents() {
    viewModel.event.bind { [weak self] (action) in
      guard let self = self else  { return }
      
      switch action {
      case .showRegister:
        self.viewModel.showSignUpView()
      case .signInTapped:
        self.viewModel.signIn()
      }
      
    }
    .disposed(by: disposeBag)
  }
}

// MARK: Keyboard Notifications
extension SignInViewController {
  
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
    scrollViewBottomContraints.constant = 0
  }
  
  private func moveContent(forKeyboardFrame keyboardFrame: CGRect) {
    scrollViewBottomContraints.constant = -keyboardFrame.height
  }
  
}
