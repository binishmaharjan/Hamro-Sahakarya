//
//  RemoveMemberViewController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/04/29.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit
import RxSwift

final class RemoveMemberViewController: UIViewController {
    
    // MARK: IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    private var viewModel: RemoveMemberViewModelProtocol!
    private let disposeBag = DisposeBag()
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindApiState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.fetchAllMembers()
    }
    
    // MARK: Methods
    private func setup() {
        title = "Remove Member"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerXib(of: MembersCell.self)
    }
}

// MARK: Bindable
extension RemoveMemberViewController {
    
    private func bindApiState() {
        viewModel.apiState
                   .driveNext { [weak self] (state) in
                       
                       switch state {
                       case .completed:
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
}

// MARK: Storyboard Instantiable
extension RemoveMemberViewController: StoryboardInstantiable {
    
    static func makeInstance(viewModel: RemoveMemberViewModelProtocol) -> RemoveMemberViewController {
        let viewController = RemoveMemberViewController.loadFromStoryboard()
        viewController.viewModel = viewModel
        return viewController
    }
}

// MARK: UITableView DataSource
extension RemoveMemberViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(of: MembersCell.self, for: indexPath)
        let cellViewModel = viewModel.viewModelForRow(at: indexPath)
        cell.bind(viewModel: cellViewModel)
        return cell
    }
    
    private func isUserSelected(indexPath: IndexPath) -> Bool {
        let member = viewModel.userProfileForRow(at: indexPath)
        return viewModel.isUserSelected(userProfile: member)
        
    }
}

// MARK: UITableView Delegate
extension RemoveMemberViewController: UITableViewDelegate {
    
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
           viewModel.selectedMember.accept(userProfile)
           
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

// MARK: Associated View
extension RemoveMemberViewController: ViewControllerWithAssociatedView {
    
    func getAssociateView() -> ProfileMainView {
        return .removeMember
    }
}