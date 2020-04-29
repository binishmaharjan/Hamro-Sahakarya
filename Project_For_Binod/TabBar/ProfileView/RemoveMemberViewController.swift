//
//  RemoveMemberViewController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/04/29.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit

final class RemoveMemberViewController: UIViewController {
    
    // MARK: IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    private var viewModel: RemoveMemberViewModelProtocol!
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: Methods
    private func setup() {
        title = "Remove Member"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerXib(of: MembersCell.self)
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
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(of: MembersCell.self, for: indexPath)
        return cell
    }
    
}

// MARK: UITableView Delegate
extension RemoveMemberViewController: UITableViewDelegate {
    
}

// MARK: Associated View
extension RemoveMemberViewController: ViewControllerWithAssociatedView {
    
    func getAssociateView() -> ProfileMainView {
        return .removeMember
    }
}
