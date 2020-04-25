//
//  HomeMainViewController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/04/25.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit
import RxSwift

final class HomeMainViewController: NiblessNavigationController {
    
    // MARK: Properties
    private let viewModel: HomeMainViewModelProtocol
    private let disposeBag = DisposeBag()
    private let homeViewControllerFactory: HomeViewControllerFactory
    
    init(viewModel: HomeMainViewModelProtocol, homeViewControllerFactory: HomeViewControllerFactory) {
        self.viewModel = viewModel
        self.homeViewControllerFactory = homeViewControllerFactory
        super.init(rootViewController: homeViewControllerFactory.makeHomeViewController())
        
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
        tabBarItem.image = UIImage(named: "icon_home")?.withRenderingMode(.alwaysOriginal)
        tabBarItem.selectedImage = UIImage(named: "icon_home_h")?.withRenderingMode(.alwaysOriginal)
        tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
    }
    
    private func subscribe(to observable: Observable<HomeNavigationAction>) {
        observable.distinctUntilChanged()
            .subscribeNext { [weak self] action in
                guard let this = self else { return }
                this.respond(to: action)
        }.disposed(by: disposeBag)
    }
    
    private func respond(to navigationAction: HomeNavigationAction) {
        switch navigationAction {
            
        case .present:
            break
        case .presented:
            break
        }
    }
}
