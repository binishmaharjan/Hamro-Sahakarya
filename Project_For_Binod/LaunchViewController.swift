//
//  LaunchViewController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/10/19.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class LaunchViewController: NiblessViewController {
  
  // MARK: Properties
  private let viewModel: LaunchViewModel
  private let disposeBag = DisposeBag()
  
  // MARK: Init
  init(launchViewModelFactory: LaunchViewModelFactory) {
    self.viewModel = launchViewModelFactory.makeLaunchViewModel()
    super.init()
  }
  
  // MARK: Methods
  override func loadView() {
    view = LaunchRootView.makeInstance(viewModel: viewModel)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    observeErrorMessage()
  }
  
  private func observeErrorMessage() {
    viewModel.errorMessage
      .asDriver { _ in fatalError("Unexpected Error on Launch View") }
      .drive(onNext: { [weak self] errorMessage in
        guard let self = self else { return }
        self.present(errorMessage: errorMessage,
                     withPresentationState: self.viewModel.errorPresentation)
      })
      .disposed(by: disposeBag)
  }
}

protocol LaunchViewModelFactory {
  
  func makeLaunchViewModel() -> LaunchViewModel
}
