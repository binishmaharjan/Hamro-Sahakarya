//
//  LaunchRootView.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/10/19.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit

class LaunchRootView: UIView {
  
  // MARK: Properties
  private var viewModel: LaunchViewModel!
  
  // MARK: Methods
  static func makeInstance(viewModel: LaunchViewModel) -> LaunchRootView {
    let rootView = LaunchRootView.loadXib()
    rootView.viewModel = viewModel
    return rootView
  }
  
  private func loadUserSession() {
    viewModel.loadUserSession()
  }
  
}

// MARK: Has Associated Xib File
extension LaunchRootView: HasXib { }
