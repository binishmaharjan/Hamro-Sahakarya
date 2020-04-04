//
//  AddMonthlyFeeViewController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/03/17.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class AddMonthlyFeeViewController: UIViewController {
    
    // MARK: IBOutlet
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var monthlyAmountTextField: UITextField!
    
    private var viewModel: AddMonthlyFeeViewModel!
    private let disposeBag = DisposeBag()
    
    private var addButton: UIBarButtonItem!
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupBarButton()
        bind()
        bindApiState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getAllMembers()
    }
    
    // MARK: Methods
    private func setup() {
        title = "Add Monthly Fee"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerXib(of: MembersCell.self)
    }
    
    private func setupBarButton() {
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func addButtonPressed() {
        viewModel.addMonthlyFee()
    }
}

// MARK: Bindable
extension AddMonthlyFeeViewController {
    private func bindApiState() {
        
        viewModel.apiState
            .withLatestFrom(viewModel.addMonthlyFeeSuccessful) { return ($0, $1) }
            .driveNext { [weak self] (state, isAddMonthlyFeeSuccessful) in
                
                switch state {
                case .completed:
                    if isAddMonthlyFeeSuccessful {
                        let dropDownModel = DropDownModel(dropDownType: .success, message: "Monthly Fee Was Added Successfully")
                        GUIManager.shared.showDropDownNotification(data: dropDownModel)
                    } else {
                        self?.tableView.reloadData()
                    }
                    
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
    
    private func bind() {
        // Input
        monthlyAmountTextField.rx.text.asDriver()
            .map { Int($0 ?? "0") ?? 0 }
            .drive(viewModel.monthAmountInput)
            .disposed(by: disposeBag)
        
        // Output
        viewModel
            .isAddButtonEnabled
            .asDriver(onErrorJustReturn: true)
            .drive(addButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}

// MARK: Storyboard Instantiable
extension AddMonthlyFeeViewController: StoryboardInstantiable {
    static func makeInstance(viewModel: AddMonthlyFeeViewModel) -> AddMonthlyFeeViewController {
        let viewController = AddMonthlyFeeViewController.loadFromStoryboard()
        viewController.viewModel = viewModel
        return viewController
    }
}

// MARK: UITableViewDataSource
extension AddMonthlyFeeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(of: MembersCell.self, for: indexPath)
        cell.tintColor = UIColor.mainOrange
        
        let row = viewModel.getRow(at: indexPath)
        switch row {
            
        case .all:
            reloadAllCell(cell, indexPath: indexPath)
        case let .member(_, viewModel):
            reloadMemberCell(cell, indexPath: indexPath, cellViewModel: viewModel)
        }
        
        return cell
    }
    
    private func reloadAllCell(_ cell: MembersCell, indexPath: IndexPath) {
        cell.makeAllCell()
        cell.accessoryType = viewModel.getAccessoryTypeForRow(at: indexPath)
    }
    
    private func reloadMemberCell(_ cell: MembersCell, indexPath: IndexPath, cellViewModel: MemberCellViewModel) {
        cell.bind(viewModel: cellViewModel)
        cell.accessoryType = viewModel.getAccessoryTypeForRow(at: indexPath)
    }
    
    func reloadCell(_ cell: MembersCell, indexPath: IndexPath) {
        let row = viewModel.getRow(at: indexPath)
        switch row {
        case .all:
            reloadAllCell(cell, indexPath: indexPath)
        case let .member(_, viewModel):
            reloadMemberCell(cell, indexPath: indexPath, cellViewModel: viewModel)
        }
    }
}

// MARK: UITableViewDelegate
extension AddMonthlyFeeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let numberOfRows = viewModel.numberOfRows(for: section)
        return numberOfRows == 0 ? 0 : 24
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.getHeaderTitle(for: section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = viewModel.getRow(at: indexPath)
        switch row {
        case .all:
            viewModel.deselectAllMember()
        case .member(let userProfile, _):
            viewModel.toggleSelected(member: userProfile)
        }
        
        let visibleIndexPath = tableView.indexPathsForVisibleRows ?? []
        let visibleCell = tableView.visibleCells as! [MembersCell]
        zip(visibleIndexPath, visibleCell).forEach { (indexPath, cell) in
            reloadCell(cell, indexPath: indexPath)
        }
    }
    
}
