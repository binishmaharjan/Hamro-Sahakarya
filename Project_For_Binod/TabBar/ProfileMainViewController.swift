//
//  ProfileMainViewController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/01/28.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileMainViewController: NiblessNavigationController {
  
  // MARK: Properties
  private let viewModel: ProfileMainViewModel
  private let disposeBag = DisposeBag()
  
  // MARK: Init
  init(viewModel: ProfileMainViewModel) {
    self.viewModel = viewModel
    super.init()
    
    setup()
  }
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    subscribe(to: viewModel.view)
  }
  
  // MARK: Methods
  private func setup() {
    title = nil
    tabBarItem.image = UIImage(named: "icon_profile")?.withRenderingMode(.alwaysOriginal)
    tabBarItem.selectedImage = UIImage(named: "icon_profile_h")?.withRenderingMode(.alwaysOriginal)
    tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
    setNavigationBarHidden(false, animated: false)
    delegate = self
  }
  
  private func subscribe(to observable: Observable<ProfileMainNavigationAction>) {
    observable.distinctUntilChanged()
      .subscribe(onNext: { [weak self] action in
      guard let self = self else { return }
      self.respond(to: action)
    }).disposed(by: disposeBag)
  }
  
  private func respond(to navigationAction: ProfileMainNavigationAction) {
     switch navigationAction {
     case let .present(view):
       present(profileMainView: view)
     case .presented:
       break
     }
   }
}

// MARK: Presentation
extension ProfileMainViewController {
  private func present(profileMainView: ProfileMainView) {
    switch profileMainView {
      
    case .profileView:
      presentProfileView()
    case .changePicture:
      break
    case .changePassword:
      break
    case .members:
      break
    case .termsOfAgreement:
      break
    case .licence:
      break
    case .logout:
      break
    }
  }
  
  private func presentProfileView() {
    let viewController = ProfileViewController()
    addFullScreen(childViewController: viewController)
  }
}

// MARK: UINavigation Controller Delegate
extension ProfileMainViewController: UINavigationControllerDelegate {
  func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
    guard let shownView = profileMainView(assoiatedWith: viewController) else { return }
    viewModel.uiPresented(profileView: shownView)
  }
  
  private func profileMainView(assoiatedWith viewController: UIViewController) -> ProfileMainView? {
    switch viewController {
    case is ProfileViewController:
        return .profileView
    default:
      fatalError("Unknown View")
    }
  }
}
