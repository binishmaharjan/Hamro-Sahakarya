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
    
    // MARK: IBOutlets
    @IBOutlet private weak var myBalanceLabel: UILabel!
    @IBOutlet private weak var loanTakenLabel: UILabel!
    @IBOutlet private weak var dateJoinedLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    
    // MARK: Properties
    private var viewModel: HomeViewModelProtocol!
    private let disposeBag = DisposeBag()

    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
}

// MARK: Bindable
extension HomeViewController {
    
    private func bind() {
        // Output
        viewModel.myBalance
            .asDriver(onErrorJustReturn: "¥0")
            .drive(myBalanceLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.loanTaken
            .asDriver(onErrorJustReturn: "¥0")
            .drive(loanTakenLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.dateJoined
            .asDriver(onErrorJustReturn: "")
            .drive(dateJoinedLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.status
            .asDriver(onErrorJustReturn: .member)
            .map { $0.rawValue }
            .drive(statusLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.username
            .asDriver(onErrorJustReturn: "")
            .drive(usernameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.email
            .asDriver(onErrorJustReturn: "")
            .drive(emailLabel.rx.text)
            .disposed(by: disposeBag)
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
