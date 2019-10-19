//
//  SingleSelectionViewController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/06/01.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit

class SingleSelectionViewController: HSViewController {
  
  let singleSelectionView = SingleSelectionView.loadXib()
  var allUser = [HSMemeber]() {
    didSet {
      singleSelectionView.tableView.reloadData()
    }
  }
  var singleSelectionType: SingleSelectionType = .removeAdmin {
    didSet {
      singleSelectionView.navigationTitleLabel.text = singleSelectionType.rawValue
      singleSelectionView.setupDailouge(with: singleSelectionType)
    }
  }
  
  override func loadView() {
    self.view = singleSelectionView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupSingleSelectionView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.downloadAllUser()
  }
  
  private func setupSingleSelectionView() {
    singleSelectionView.tableView.delegate = self
    singleSelectionView.tableView.dataSource = self
    singleSelectionView.backButton.delegate = self
    singleSelectionView.cancelButton.delegate = self
    singleSelectionView.okButton.delegate = self
    singleSelectionView.tableView.register(SelectionViewCell.loadNib(), forCellReuseIdentifier: SelectionViewCell.xibName)
  }
  
}

extension SingleSelectionViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return allUser.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: SelectionViewCell.xibName, for: indexPath) as? SelectionViewCell {
      cell.user = user(forRowAt: indexPath)
      return cell
    }
    
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    singleSelectionView.selectedUserLabel(with: user(forRowAt: indexPath))
    singleSelectionView.showDialouge()
  }
  
  func user(forRowAt index: IndexPath) -> HSMemeber {
    return allUser[index.row]
  }
}

extension SingleSelectionViewController: HSUserDatabase {
  
  private func downloadAllUser() {
    self.fetchAllUser { [weak self] (users, error) in
      if let error = error {
        Dlog(error.localizedDescription)
        return
      }
      
      guard let users = users else {
        Dlog(EMPTY_DATA_ERROR.localizedDescription)
        return
      }
      
      self?.allUser = users
    }
  }
}

extension SingleSelectionViewController: HSButtonViewDelegate {
  func buttonViewTapped(view: HSButtonView) {
    if view == singleSelectionView.backButton {
      self.navigationController?.popViewController(animated: true)
    } else if view == singleSelectionView.cancelButton {
      singleSelectionView.hideDailouge()
    } else if view == singleSelectionView.okButton {
      //Change
    }
  }
}

struct CellState {
  var allUser: [HSMemeber]
  var selectedUser: HSMemeber
  
  init(allUser: [HSMemeber]) {
    self.allUser = allUser
    selectedUser = HSMemeber(uid: "", username: "", email: "", status: "", colorHex: "", iconUrl: "", dateCreated: "", keyword: "", loanTaken: 0, balance: 0, dateUpdated: "")
  }
  
  func isSelected(user: HSMemeber) -> Bool {
    return selectedUser == user
  }
  
  mutating func select(_ user: HSMemeber) {
    selectedUser = user
  }
}
