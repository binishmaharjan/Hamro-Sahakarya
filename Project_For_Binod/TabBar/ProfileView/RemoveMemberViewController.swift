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

// MARK: Associated View
extension RemoveMemberViewController: ViewControllerWithAssociatedView {
    
    func getAssociateView() -> ProfileMainView {
        return .removeMember
    }
}
