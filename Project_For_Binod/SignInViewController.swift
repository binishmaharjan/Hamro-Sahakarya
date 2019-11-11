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
  }

}
