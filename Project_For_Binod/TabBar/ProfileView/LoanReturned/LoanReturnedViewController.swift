//
//  LoanReturnedViewController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/04/17.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation
import UIKit

final class LoanReturnedViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet private weak var amountTextField: UITextField!
    @IBOutlet private weak var tableView: UITableView!
    
    private var viewModel: LoanReturnedViewModelProtocol!
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
