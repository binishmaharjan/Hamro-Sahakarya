//
//  LoanMemberViewController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/04/11.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class LoanMemberViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var loanAmountTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    private var viewModel: LoanMemberViewModelProtocol!
    private var disposeBag =  DisposeBag()
    private var addButton: UIBarButtonItem!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBarButton()
        
        bindApiState()
        bindUIState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.getAllMembers()
    }
    
    private func setupBarButton() {
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func addButtonPressed() {
        viewModel.loanMember()
    }
}


// MARK: Storyboard Instantiable
extension LoanMemberViewController: StoryboardInstantiable {
    
    static func  makeInstance(viewModel: LoanMemberViewModelProtocol) -> LoanMemberViewController {
        let viewController = LoanMemberViewController.loadFromStoryboard()
        viewController.viewModel = viewModel
        return viewController
    }
}

// MARK: Bindable
extension LoanMemberViewController {
    
    private func bindApiState() {
        
        viewModel.apiState
            .withLatestFrom(viewModel.loanMemberSuccessful) { return ($0, $1) }
            .driveNext { [weak self] (state, loanMemberSuccessful) in
                
                switch state {
                case .completed:
                    if loanMemberSuccessful {
                        let dropDownModel = DropDownModel(dropDownType: .success, message: "Successful!!!")
                        GUIManager.shared.showDropDownNotification(data: dropDownModel)
                        
                        self?.loanAmountTextField.text = ""
                    } else {
                        self?.tableView.reloadData()
                    }
                    
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
    
    private func bindUIState() {
        // Input
        loanAmountTextField.rx.text
            .asDriver()
            .map { Int($0 ?? "0") ?? 0 }
            .drive(viewModel.loanAmount)
            .disposed(by: disposeBag)
        
        // Output
        viewModel
            .isLoanMemberButtonEnabled
            .asDriver(onErrorJustReturn: false)
            .drive(addButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}
