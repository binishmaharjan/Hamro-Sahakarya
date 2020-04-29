//
//  ExtraAndExpensesViewController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/04/08.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ExtraAndExpensesViewController: UIViewController {
    
    // MARK: IBOutlet
    @IBOutlet private weak var typeTextField: UILabel!
    @IBOutlet private weak var amountTextField: UITextField!
    @IBOutlet private weak var reasonTextView: UITextView!
    @IBOutlet private weak var confirmButton: UIButton!
    
    // MARK: Properties
    private var viewModel: ExtraAndExpensesViewModel!
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindApiState()
        bindUIState()
        
        setup()
    }
    
    private func setup() {
        title = "Extra Or Expenses"
        
        let typeSelectionTapGesture = UITapGestureRecognizer(target: self, action: #selector(typeSelectionTapped))
        typeTextField.addGestureRecognizer(typeSelectionTapGesture)
    }
    
    @objc private func typeSelectionTapped() {
        showTypeSelectionSheet()
    }
    
    private func showTypeSelectionSheet() {
        let actionSheet = UIAlertController(title: "Type Selection", message: "Extra Or Expenses", preferredStyle: .actionSheet)
        let actions = ExtraOrExpenses.allCases.map { [weak self] type -> UIAlertAction in
            
            let action = UIAlertAction(title: type.rawValue, style: .default) { (_) in
                   self?.viewModel.selectedTypeInput.accept(type)
                 }
                 
                 return action
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        actions.forEach { actionSheet.addAction($0) }
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
    
    // MARK: IBActions
    @IBAction private func confirmButtonPressed(_ sender: Any) {
        viewModel.updateExtraOrExpenses()
    }
}

// MARK: Storyboard Instantiable
extension ExtraAndExpensesViewController: StoryboardInstantiable {
    
    static func makeInstance(viewModel: ExtraAndExpensesViewModel) -> ExtraAndExpensesViewController {
        let viewController = ExtraAndExpensesViewController.loadFromStoryboard()
        viewController.viewModel = viewModel
        return viewController
    }
}

// MARK: Bindable
extension ExtraAndExpensesViewController {
    
    private func bindApiState() {
        viewModel.apiState.driveNext { [weak self] (state) in
            switch state {
            case .completed:
                GUIManager.shared.stopAnimation()
                
                let dropDownModel = DropDownModel(dropDownType: .success, message: "SuccessFul!!!")
                GUIManager.shared.showDropDownNotification(data: dropDownModel)
                
                self?.amountTextField.text = "0"
                self?.reasonTextView.text = ""
                
            case .error(let error):
                let dropDownModel = DropDownModel(dropDownType: .error, message: error.localizedDescription)
                GUIManager.shared.showDropDownNotification(data: dropDownModel)
                
                GUIManager.shared.stopAnimation()
                
            case .loading:
                GUIManager.shared.startAnimation()
                
            default:
                break
            }
        }.disposed(by: disposeBag)
    }
    
    private func bindUIState() {
        // Input
        amountTextField.rx.text
            .asDriver()
            .map { Int($0 ?? "0") ?? 0 }
            .drive(viewModel.amountInput)
            .disposed(by: disposeBag)
        
        reasonTextView.rx.text
            .asDriver()
            .map { $0 ?? "" }
            .drive(viewModel.reasonInput)
            .disposed(by: disposeBag)
        
        // Output
        viewModel.isConfirmButtonEnabled
            .asDriver(onErrorJustReturn: false)
            .drive(confirmButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.selectedTypeInput
            .asDriver(onErrorJustReturn: .extra)
            .map { $0.rawValue }
            .drive(typeTextField.rx.text)
            .disposed(by: disposeBag)
    }
}

// MARK: Get Associated View
extension ExtraAndExpensesViewController: ViewControllerWithAssociatedView {
    func getAssociateView() -> ProfileMainView {
        return .extraAndExpenses
    }
    
}
