//
//  ChangePasswordViewController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/03/01.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth

final class ChangePasswordViewController: KeyboardObservingViewController {
  
  @IBOutlet private weak var passwordTextField: UITextField!
  @IBOutlet private weak var confirmPasswordField: UITextField!
  @IBOutlet private weak var changePasswordButton: MainOrangeButton!
  
  private var viewModel: ChangePasswordViewModel!
  private let disposebag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    bind()
    bindApiState()
  }
  
  private func setup() {
    title = "Change Password"
  }
  
  @IBAction func changePasswordButtonPressed(_ sender: Any) {
    viewModel.changePassword()
  }
  
}

// MARK: Bindable
extension ChangePasswordViewController {
  private func bind() {
    // Input
    passwordTextField.rx.text
      .asDriver().map { $0 ?? "" }
      .drive(viewModel.passwordInput)
      .disposed(by: disposebag)
    
    confirmPasswordField.rx.text
      .asDriver().map { $0 ?? "" }
      .drive(viewModel.confirmPasswordInput)
      .disposed(by: disposebag)
    
    // Output
    viewModel.isChangePasswordButtonEnabled
      .asDriver(onErrorJustReturn: true)
      .drive(changePasswordButton.rx.isEnabled)
      .disposed(by: disposebag)
  }
  
  private func bindApiState() {
    viewModel.apiState.drive(onNext: { [weak self] (state) in
      switch state {
      case .idle:
        break
      case .completed:
        GUIManager.shared.stopAnimation()
        
        let dropDownModel = DropDownModel(dropDownType: .success, message: "Change Password Successful")
        GUIManager.shared.showDropDownNotification(data: dropDownModel)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          self?.viewModel.signOut()
        }
      case .error(let error):
        GUIManager.shared.stopAnimation()
        
        let dropDownModel = DropDownModel(dropDownType: .error, message: error.localizedDescription)
        GUIManager.shared.showDropDownNotification(data: dropDownModel)
      case .loading:
         GUIManager.shared.startAnimation()
      }
    }).disposed(by: disposebag)
  }
}

// MARK: Storyboard Instantiable
extension ChangePasswordViewController: StoryboardInstantiable {
  static func makeInstance(viewModel: ChangePasswordViewModel) -> ChangePasswordViewController {
    let viewController = ChangePasswordViewController.loadFromStoryboard()
    viewController.viewModel = viewModel
    return viewController
  }
}
