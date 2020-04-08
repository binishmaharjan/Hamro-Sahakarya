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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
