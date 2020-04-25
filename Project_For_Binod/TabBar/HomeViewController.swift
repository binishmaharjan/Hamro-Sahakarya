//
//  HomeViewController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/01/18.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit
import RxSwift

final class HomeViewController: UIViewController {
    
    private var viewModel: HomeViewModelProtocol!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

// MARK: Storyboard Instantiable
extension HomeViewController: StoryboardInstantiable {
    
    static func makeInstance(viewModel: HomeViewModelProtocol) -> HomeViewController {
        let viewController = loadFromStoryboard()
        viewController.viewModel = viewModel
        return viewController
    }
}

// MARK: Storyboard Instantiable
extension HomeViewController: AssociatedHomeView {
    func getAssociateView() -> HomeView {
        return .home
    }
    
}
