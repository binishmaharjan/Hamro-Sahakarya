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

protocol ViewControllerWithAssociatedView {
    func getAssociateView() -> ProfileMainView
}

final class ProfileMainViewController: NiblessNavigationController {
    
    // MARK: Properties
    private let viewModel: ProfileMainViewModel
    private let disposeBag = DisposeBag()
    
    // Child View Controller Factory
    private let profileViewControllerFactory: ProfileViewControllerFactory
    
    // MARK: Init
    init(viewModel: ProfileMainViewModel,
         profileViewController: ProfileViewController,
         profileViewControllerFactory: ProfileViewControllerFactory) {
        
        self.viewModel = viewModel
        self.profileViewControllerFactory = profileViewControllerFactory
        super.init(rootViewController: profileViewController)
        
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
            break
        case .changePicture:
            showChangeProfileView()
        case .changePassword:
            showChangePasswordView()
        case .members:
            showMembersView()
        case .changeMemberStatus:
            showChangeMemberStatusView()
        case .extraAndExpenses:
            showExtraAndExpenseView()
        case .loanMember:
            showLoanMemberView()
        case .loanReturned:
            showLoanReturnedView()
        case .termsOfAgreement:
            break
        case .licence:
            break
        case .logout:
            break
        case .addMonthlyFee:
            showAddMonthlyFeeView()
        }
    }
    
    private func showChangeProfileView() {
        let viewController = profileViewControllerFactory.makeChangePictureViewController()
        pushViewController(viewController, animated: true)
    }
    
    private func showMembersView() {
        let viewController = profileViewControllerFactory.makeMembersViewController()
        pushViewController(viewController, animated: true)
    }
    
    private func showChangePasswordView() {
        let viewController = profileViewControllerFactory.makeChangePasswordViewController()
        pushViewController(viewController, animated: true)
    }
    
    private func showChangeMemberStatusView() {
        let viewController = profileViewControllerFactory.makeChangeMemberStatusViewController()
        pushViewController(viewController, animated: true)
    }
    
    private func showAddMonthlyFeeView() {
        let viewController = profileViewControllerFactory.makeAddMonthlyFeeViewController()
        pushViewController(viewController, animated: true)
    }
    
    private func showExtraAndExpenseView() {
        let viewController = profileViewControllerFactory.makeExtranAndExpensesViewController()
        pushViewController(viewController, animated: true)
    }
    
    private func showLoanMemberView() {
        let viewController = profileViewControllerFactory.makeLoanMemberViewController()
        pushViewController(viewController, animated: true)
    }
    
    private func showLoanReturnedView() {
        let viewController = profileViewControllerFactory.makeLoanReturnedViewController()
        pushViewController(viewController, animated: true)
    }
}

// MARK: UINavigation Controller Delegate
extension ProfileMainViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let shownView = profileMainView(assoiatedWith: viewController) else {
            return
        }
        
        viewModel.uiPresented(profileView: shownView)
    }
    
    private func profileMainView(assoiatedWith viewController: UIViewController) -> ProfileMainView? {
        
        guard let viewController = viewController as? ViewControllerWithAssociatedView else {
            fatalError("ViewController doesnot have associated view")
        }
        
        return viewController.getAssociateView()
    }
}
