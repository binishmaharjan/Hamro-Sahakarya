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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.registerXib(of: ProfileTopCell.self)
    tableView.delegate = self
    tableView.dataSource = self
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
      cell.bind(viewModel: viewModel)
      return cell
    case .changePicture:
      let cell = UITableViewCell()
      cell.textLabel?.text = "Change Picture"
      return cell
    case .changePassword:
      let cell = UITableViewCell()
      cell.textLabel?.text = "Change Password"
      return cell
    case .members:
      let cell = UITableViewCell()
      cell.textLabel?.text = "Members"
      return cell
    }
  }
}

// MARK: TableView Delegate
extension ProfileViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return section == 0 ? 0 : 10
  }
  
}

enum ProfileRow {
  case top(ProfileTopCellViewModel)
  case changePicture
  case changePassword
  case members
}

struct ProfileSection {
  let rows: [ProfileRow]
}

protocol ProfileViewModel {
  var userSession: UserSession { get }
  var notSignedInResponder: NotSignedInResponder { get }
  var numberOfSection: Int { get }
  
  func signOut()
  func numberOfRows(in section: Int) -> Int
  func row(for indexPath: IndexPath) -> ProfileRow
}

struct DefaultProfileViewModel: ProfileViewModel {

  // MARK: Properties
  let userSession: UserSession
  let notSignedInResponder: NotSignedInResponder
  let userSessionRepository: UserSessionRepository
  
  // Data Source
  var profileSections: [ProfileSection] {
    let section = [
      ProfileSection(rows: [.top(DefaultProfileTopCellViewModel(userSession: userSession))]),
      ProfileSection(rows: [.changePicture, .changePassword, .members])
    ]
    return section
  }
  
  var numberOfSection: Int {
    return profileSections.count
  }
  
  // MARK: Init
  init(userSession: UserSession,
       notSignedInResponder: NotSignedInResponder,
       userSessionRepository: UserSessionRepository) {
    self.userSession = userSession
    self.notSignedInResponder = notSignedInResponder
    self.userSessionRepository = userSessionRepository
  }
  
  // MARK: Methods
  func signOut() {
    userSessionRepository.signOut(userSession: userSession)
      .done(indicateSignoutSuccessful)
      .catch(indicateError)
  }
  
  func numberOfRows(in section: Int) -> Int {
    return profileSections[section].rows.count
  }
  
  func row(for indexPath: IndexPath) -> ProfileRow {
    return profileSections[indexPath.section].rows[indexPath.row]
  }
  
  private func indicateSignoutSuccessful(userSession: UserSession) {
    
  }
  
  private func indicateError(error: Error) {
    
  }
}
