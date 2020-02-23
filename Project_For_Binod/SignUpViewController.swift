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

final class SignUpViewController: KeyboardObservingViewController {
  
  // MARK: IBOutlets
  @IBOutlet private weak var emailTextField: UITextField!
  @IBOutlet private weak var fullNameTextField: UITextField!
  @IBOutlet private weak var passwordTextField: UITextField!
  @IBOutlet private weak var statusLabel: UILabel!
  @IBOutlet private weak var colorView: UIView!
  @IBOutlet private weak var initialAmountTextField: UITextField!
  @IBOutlet private weak var signUpButton: UIButton!

  
  // MARK: Properties
  private var viewModel: SignUpViewModel!
  private let disposeBag = DisposeBag()
  private var colorPickerFactory: ColorPickerViewControllerFactory!
  
  // MARK: LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    bind()
    bindEventActions()
    bindApiState()
  }

  // Methods
  private func setup() {
    // Color View
    let colorViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(colorViewTapped))
    colorView.addGestureRecognizer(colorViewTapGesture)
    
    // Status Label
    let statusLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(statusLabelTapped))
    statusLabel.addGestureRecognizer(statusLabelTapGesture)
    
    // Dimiss Keyboard
    let viewTapGesture = UITapGestureRecognizer(target: self, action: #selector(signUpViewTapped))
    view.addGestureRecognizer(viewTapGesture)
  }
  
  @objc private func colorViewTapped() {
    viewModel.colorViewTapped.onNext(())
  }
  
  @objc private func statusLabelTapped() {
    viewModel.statusLabelTapped.onNext(())
  }
  
  @objc private func signUpViewTapped() {
    view.endEditing(true)
  }
  
  /// Show action sheet for the member status selection
  private func showStatusSelectionAlert() {
    let alertController = UIAlertController(title: "Select Member Status", message: "Choose from below", preferredStyle: .actionSheet)
    let statusActions = Status.allCases.map { [weak self] status -> UIAlertAction in
      
      let action = UIAlertAction(title: status.rawValue, style: .default) { (_) in
        self?.viewModel.statusInput.accept(status)
      }
      
      return action
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    
    statusActions.forEach { alertController.addAction($0) }
    alertController.addAction(cancelAction)
    
    present(alertController, animated: true)
  }
  
  private func colorSelectedOnPicker(hex: String) {
    viewModel.colorInput.accept(hex)
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
    // Input
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
    
    initialAmountTextField.rx.text.asDriver()
      .map { Int($0 ?? "0") ?? 0 }
      .drive(viewModel.initialAmountInput)
      .disposed(by: disposeBag)
    
    // Output
    viewModel.statusInput.asObservable()
      .map { $0.rawValue}
      .bind(to: statusLabel.rx.text)
      .disposed(by: disposeBag)
    
    viewModel.colorInput.asObservable()
      .map { UIColor(hex: $0) }
      .bind(to: colorView.rx.backgroundColor)
      .disposed(by: disposeBag)
  }
  
  private func bindEventActions() {
    viewModel.event.bind { [weak self] (action) in
      guard let self = self else { return }
      
      switch action {
      case .signUpButtonTapped:
        self.viewModel.signUp()
      case .backButtonTapped:
        self.navigationController?.popViewController(animated: true)
      case .colorViewTapped:
        let colorPickerViewController = self.colorPickerFactory.makeColorPickerViewController()
        colorPickerViewController.colorSelected = self.colorSelectedOnPicker(hex:)
        
        self.present(colorPickerViewController, animated: true)
      case .statusLabelTapped:
        self.showStatusSelectionAlert()
      }
    }.disposed(by: disposeBag)
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

// MARK: Storyboard Instantiable
extension SignUpViewController: StoryboardInstantiable {
  
  static func makeInstance(viewModelFactory: SignUpViewModelFactory,
                           colorPickerFactory: ColorPickerViewControllerFactory) -> SignUpViewController {
    let viewController = loadFromStoryboard()
    viewController.viewModel = viewModelFactory.makeSignUpViewModel()
    viewController.colorPickerFactory = colorPickerFactory
    
    return viewController
  }
}
