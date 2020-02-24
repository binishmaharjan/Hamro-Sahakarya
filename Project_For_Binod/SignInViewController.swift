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

final class SignInViewController: KeyboardObservingViewController {

  // MARK: IBOutlet
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
    bindApiState()
    observeErrorMessages()
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
    // Input
    emailTextField.rx.text.asDriver()
      .map { $0 ?? "" }
      .drive(viewModel.emailInput)
      .disposed(by: disposeBag)
    
    passwordTextField.rx.text.asDriver()
      .map { $0 ?? "" }
      .drive(viewModel.passwordInput)
      .disposed(by: disposeBag)

    // Output
    viewModel.isSignInEnabled
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
      case .none:
        break
      }

    }
    .disposed(by: disposeBag)
  }
  
  private func bindApiState() {
    viewModel.apiState.drive(onNext: { state in
      switch state {
        
      case .idle:
        break
        
      case .completed:
        GUIManager.shared.stopAnimation()
        
      case .error(let error):
        GUIManager.shared.stopAnimation()
        
        let dropDownModel = DropDownModel(dropDownType: .error, message: error.localizedDescription)
        GUIManager.shared.showDropDownNotification(data: dropDownModel)
        
      case .loading:
        GUIManager.shared.startAnimation()
      }
      
    }
    ).disposed(by: disposeBag)
  }
}
