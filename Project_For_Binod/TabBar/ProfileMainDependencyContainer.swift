//
//  ProfileMainDependencyContainer.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/01/28.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation

final class ProfileMainDependencyContainer {
  // MARK: Properties
  private let sharedUserSessionRepository: UserSessionRepository
  private let sharedMainViewModel: MainViewModel
  
  private let profileMainViewModel: ProfileMainViewModel
  
  // MARK: Init
  init(dependencyContainer: SignedInDepedencyConatiner) {
    func makeProfileMainViewModel() -> ProfileMainViewModel {
      return DefaultProfileMainViewModel()
    }
    
    self.sharedMainViewModel = dependencyContainer.sharedMainViewModel
    self.sharedUserSessionRepository = dependencyContainer.sharedUserSessionRepository
    
    self.profileMainViewModel = makeProfileMainViewModel()
  }
}

// MARK: Profile Main View Controller
extension ProfileMainDependencyContainer {
  
  func makeProfileMainViewController() -> ProfileMainViewController {
    let viewModel = profileMainViewModel
    return ProfileMainViewController(viewModel: viewModel)
  }
}

