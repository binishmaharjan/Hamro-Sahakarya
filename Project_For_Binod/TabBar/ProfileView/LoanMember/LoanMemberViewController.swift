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
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
