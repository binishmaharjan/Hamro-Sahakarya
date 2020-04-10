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
    @IBOutlet private weak var typeTextField: UITextField!
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
    }
    
    // MARK: IBActions
    @IBAction private func confirmButtonPressed(_ sender: Any) {
        
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
        viewModel.apiState.driveNext { (state) in
            switch state {
            case .completed:
                GUIManager.shared.stopAnimation()
                
            case .error(let error):
                let dropDownModel = DropDownModel(dropDownType: .error, message: error.localizedDescription)
                GUIManager.shared.showDropDownNotification(data: dropDownModel)
                
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
    }
}
