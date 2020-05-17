//
//  ProfileViewController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/01/18.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileViewController: UIViewController {
  
  // MARK: IBOutlet
  @IBOutlet private weak var tableView: UITableView!
  
  // MARK: Properties
  private var viewModel: ProfileViewModel!
  private let disposeBag = DisposeBag()
  
  // MARK: LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bindState()
    
    tableView.registerXib(of: ProfileTopCell.self)
    
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
  }
}

// MARK: Bindable
extension ProfileViewController {
  private func bindState() {
    viewModel.state.drive(onNext: { state in
      switch state {
      case .error(let error):
        let dropDownModel = DropDownModel(dropDownType: .error, message: error.localizedDescription)
        GUIManager.shared.showDropDownNotification(data: dropDownModel)
        
      default:
        break
      }
    }).disposed(by: disposeBag)
  }
}

// MARK: Storyboard Instantiable
extension ProfileViewController: StoryboardInstantiable {
  static func makeInstance(viewModel: ProfileViewModel) -> ProfileViewController {
    let viewController = loadFromStoryboard()
    viewController.viewModel = viewModel
    return viewController
  }
}

// MARK: TableView Datasource
extension ProfileViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return viewModel.numberOfSection
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfRows(in: section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let row = viewModel.row(for: indexPath)
    
    switch row {
    case .top(let viewModel):
      let cell = tableView.dequeueCell(of: ProfileTopCell.self, for: indexPath)
      cell.selectionStyle = .none
      cell.bind(viewModel: viewModel)
      return cell
      
    default:
      let cell = UITableViewCell()
      cell.accessoryType = .disclosureIndicator
      cell.textLabel?.text = row.title
      return cell
    }
  }
  
}

// MARK: TableView Delegate
extension ProfileViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return section == 0 ? .leastNonzeroMagnitude : 10
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return section == viewModel.lastSection ? 100 : .leastNonzeroMagnitude
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    guard section == viewModel.lastSection else { return nil }
    
    let footerView = ProfileFooterView.makeInstance()
    return footerView
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let row = viewModel.row(for: indexPath)
    cellPressed(for: row)
  }
  
}

// MARK: Cell Pressed Actions
extension ProfileViewController {
  
  private func cellPressed(for row:ProfileRow) {
    switch row {
      
    case .top(_):
      break
    case .changePicture:
      viewModel.navigate(to: .changePicture)
    case .changePassword:
      viewModel.navigate(to: .changePassword)
    case .members:
      viewModel.navigate(to: .members)
    case .changeStatus:
      viewModel.navigate(to: .changeMemberStatus)
    case .extraAndExpenses:
        viewModel.navigate(to: .extraAndExpenses)
    case .monthlyFee:
      viewModel.navigate(to: .addMonthlyFee)
    case .loanMember:
        viewModel.navigate(to: .loanMember)
    case .loanReturned:
        viewModel.navigate(to: .loanReturned)
    case .removeMember:
        viewModel.navigate(to: .removeMember)
    case .termsAndCondition:
        viewModel.navigate(to: .termsAndCondition)
    case .addOrDeductAmount:
        viewModel.navigate(to: .addOrDeductAmount)
    case .license:
      break
    case .logout:
      GUIManager.shared.showDialog(factory: .logoutConfirmation) { [weak self] in
        self?.viewModel.signOut()
      }
    }
    
  }
}

// MARK: Get Associate View
extension ProfileViewController: ViewControllerWithAssociatedView {
    func getAssociateView() -> ProfileMainView {
        return .profileView
    }
}
