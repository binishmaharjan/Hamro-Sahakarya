//
//  AddOrDeductAmountViewController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/05/17.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class AddOrDeductAmountViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Properties
    private var viewModel: AddOrDeductAmountViewModelProtocol!
    private var disposeBag =  DisposeBag()
    private var addButton: UIBarButtonItem!
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBarButton()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchAllMembers()
    }
    
    private func setup() {
        title = "Add Or Deduct Amount"
        
        tableView.registerXib(of: MembersCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupBarButton() {
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func addButtonPressed() {
        viewModel.addorDeduct()
    }
}

//MARK: Storyboard Instantiable
extension AddOrDeductAmountViewController: StoryboardInstantiable {
    
    static func makeInstance(viewModel: AddOrDeductAmountViewModelProtocol) -> AddOrDeductAmountViewController {
        let viewController = AddOrDeductAmountViewController.loadFromStoryboard()
        viewController.viewModel = viewModel
        return viewController
    }
}

//MARK: Associate View
extension AddOrDeductAmountViewController: ViewControllerWithAssociatedView {
    
    func getAssociateView() -> ProfileMainView {
        return .addOrDeductAmount
    }
}
