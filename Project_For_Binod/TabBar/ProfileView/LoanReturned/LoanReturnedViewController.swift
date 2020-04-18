//
//  LoanReturnedViewController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/04/17.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class LoanReturnedViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet private weak var amountTextField: UITextField!
    @IBOutlet private weak var tableView: UITableView!
    
    private var viewModel: LoanReturnedViewModelProtocol!
    private let disposeBag = DisposeBag()
    private var addButton: UIBarButtonItem!
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBarButton()
        bindApiState()
        bindState()
    }
    
    private func setupBarButton() {
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func addButtonPressed() {
        viewModel.returnAmount()
    }
}

// MARK: Storyboard Instantiable
extension LoanReturnedViewController: StoryboardInstantiable {
    
    static func makeInstance(viewModel: LoanReturnedViewModelProtocol) -> LoanReturnedViewController {
        let viewController = LoanReturnedViewController.loadFromStoryboard()
        viewController.viewModel = viewModel
        return viewController
    }
}


// MARK: Binding
extension LoanReturnedViewController {
    private func bindApiState() {
        
        viewModel.apiState
            .withLatestFrom(viewModel.returnedAmountSuccessful) { return ($0, $1) }
            .driveNext { [weak self] (state, returnedSuccessful) in
                
                switch state {
                case .completed:
                    if returnedSuccessful {
                        let dropDownModel = DropDownModel(dropDownType: .success, message: "Successful!!!")
                        GUIManager.shared.showDropDownNotification(data: dropDownModel)
                        
                        self?.amountTextField.text = ""
                    }
                        
                    self?.tableView.reloadData()
                                    
                    GUIManager.shared.stopAnimation()
                    
                case .error(let error):
                    let dropDownModel = DropDownModel(dropDownType: .error, message: error.localizedDescription)
                    GUIManager.shared.showDropDownNotification(data: dropDownModel)
                    
                case .loading:
                    GUIManager.shared.startAnimation()
                    
                default:
                    break
                }
        }
        .disposed(by: disposeBag)
    }
    
    private func bindState() {
        // Input
        amountTextField.rx.text
            .asDriver()
            .map { Int($0 ?? "0") ?? 0 }
            .drive(viewModel.returnedAmount)
            .disposed(by: disposeBag)
        
        // Output
        viewModel.isReturnAmountButtonEnabled
            .asDriver(onErrorJustReturn: false)
            .drive(addButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}
