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

// MARK: UITableView Data Soure
extension AddOrDeductAmountViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(of: MembersCell.self, for: indexPath)
        cell.tintColor = UIColor.mainOrange
        
        let cellViewModel = viewModel.viewModelForRow(at: indexPath)
        
        cell.accessoryType = isUserSelected(indexPath: indexPath) ? .checkmark : .none
        cell.bind(viewModel: cellViewModel)
        
        return cell
    }
    
    private func isUserSelected(indexPath: IndexPath) -> Bool {
        let member = viewModel.userProfileForRow(at: indexPath)
        return viewModel.isUserSelected(userProfile: member)
        
    }
    
}

// MARK: UITableView Delegate
extension AddOrDeductAmountViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Members"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let userProfile = viewModel.userProfileForRow(at: indexPath)
        viewModel.selectedUser.accept(userProfile)
        
        let visibleIndexPath = tableView.indexPathsForVisibleRows ?? []
        let visibleCell = tableView.visibleCells as! [MembersCell]
        zip(visibleIndexPath, visibleCell).forEach { (indexPath, cell) in
            reloadCell(cell, indexPath: indexPath)
        }
    }
    
    private func reloadCell(_ cell: MembersCell, indexPath: IndexPath) {
        cell.bind(viewModel: viewModel.viewModelForRow(at: indexPath))
        cell.accessoryType = isUserSelected(indexPath: indexPath) ? .checkmark : .none
    }
}

//MARK: Associate View
extension AddOrDeductAmountViewController: ViewControllerWithAssociatedView {
    
    func getAssociateView() -> ProfileMainView {
        return .addOrDeductAmount
    }
}
