//
//  LogViewController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/01/18.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class LogViewController: UIViewController {
    
    // Properties
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var noLogView: UIView!
    
    private var viewModel: LogViewModel!
    private let disposeBag = DisposeBag()
    
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindApiState()
        
        tableView.registerXib(of: LogViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.loadLogs(isFirstLoad: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: Methods
    private func setup() {
        title = nil
        navigationItem.title = "Logs"
        tabBarItem.image = UIImage(named: "icon_log")?.withRenderingMode(.alwaysOriginal)
        tabBarItem.selectedImage = UIImage(named: "icon_log_h")?.withRenderingMode(.alwaysOriginal)
        tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
    }
}

// MARK: Bind
extension LogViewController {
    
    private func bindApiState() {
        viewModel.state
            .drive(onNext: { [weak self] (state) in
                switch state {
                case .idle:
                    break
                case .completed:
                    self?.tableView.reloadData()
                    GUIManager.shared.stopAnimation()
                case .error(let error):
                    GUIManager.shared.stopAnimation()
                    
                    let dropDownModel = DropDownModel(dropDownType: .error, message: error.localizedDescription)
                    GUIManager.shared.showDropDownNotification(data: dropDownModel)
                case .loading:
                    GUIManager.shared.startAnimation()
                }
                }
        ).disposed(by: disposeBag)
    }
}

// MARK: Storyboard Instantiable
extension LogViewController: StoryboardInstantiable {
    
    static func makeInstance(viewModel: DefaultLogViewModel) -> LogViewController {
        let viewController = LogViewController.loadFromStoryboard()
        viewController.viewModel = viewModel
        viewController.setup()
        return viewController
    }
}

// MARK: Table View DataSource
extension LogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noLogView.isHidden = viewModel.count == 0 ? false : true
        return viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(of: LogViewCell.self, for: indexPath)
        cell.bind(viewModel: viewModel.logViewModelForRow(at: indexPath))
        return cell
    }
}

// MARK: Table View Delegate
extension LogViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let startFetchingMoreLogIndex = viewModel.count - viewModel.lastCount - 1
        if indexPath.row == startFetchingMoreLogIndex {
            viewModel.fetchMoreLogs()
        }
    }
    
}
