//
//  AddMonthlyFeeViewModel.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/04/04.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol AddMonthlyFeeStateProtocol {
    var monthlyFeeAmount: Int { get }
}

extension AddMonthlyFeeStateProtocol {
    var isAddButtonEnabled: Bool {
        return monthlyFeeAmount > 0
    }
}

protocol AddMonthlyFeeViewModel {
  var numberOfSection: Int { get }
  var apiState: Driver<State> { get }
  var monthAmountInput: BehaviorRelay<Int> { get }
  
  func numberOfRows(for section: Int) -> Int
  func addMonthlyFee()
  func getRow(at indexPath: IndexPath) -> AddMonthlyFeeRow
  func getAccessoryTypeForRow(at indexPath: IndexPath) -> UITableViewCell.AccessoryType
  func getHeaderTitle(for section: Int) -> String
  func getAllMembers()
  func deselectAllMember()
  func toggleSelected(member: UserProfile)
}

enum AddMonthlyFeeRow {
  case all
  case member(UserProfile, MemberCellViewModel)
}

final class DefaultAddMonthlyFeeViewModel: AddMonthlyFeeViewModel {
    
    struct UIState: AddMonthlyFeeStateProtocol {
        var monthlyFeeAmount: Int
    }
    
   struct Section {
     let rows: [AddMonthlyFeeRow]
   }
  
  private var userSessionRepository: UserSessionRepository
  private var userSession: UserSession
  
  private let dispatchGroup: DispatchGroup = DispatchGroup()
  private var addMonthlyFeeErrorHasError: Bool = false
  
  private var allMembers: [UserProfile] = []
  private var selectedMember: [UserProfile] = []
  private var tableViewSection: [Section]  {
    let section = [
      Section(rows: [AddMonthlyFeeRow.all]),
      Section(rows: allMembers.map { AddMonthlyFeeRow.member($0, DefaultMemberCellViewModel(profile: $0)) })
    ]
    
    return section
  }
  
  @PropertyBehaviourRelay<State>(value: .idle)
  var apiState: Driver<State>
  let monthAmountInput = BehaviorRelay<Int>(value: 0)
  
  var numberOfSection: Int {
    return tableViewSection.count
  }
  
  init(userSessionRepository: UserSessionRepository, userSession: UserSession) {
    self.userSessionRepository = userSessionRepository
    self.userSession = userSession
  }
  
  // MARK: Binding Values
  func getRow(at indexPath: IndexPath) -> AddMonthlyFeeRow {
    return tableViewSection[indexPath.section].rows[indexPath.row]
  }
  
  func numberOfRows(for section: Int) -> Int {
    return tableViewSection[section].rows.count
  }
  
  func getHeaderTitle(for section: Int) -> String {
    return section == 0 ? "All" : "Members"
  }
  
  func getAccessoryTypeForRow(at indexPath: IndexPath) -> UITableViewCell.AccessoryType {
    let row = getRow(at: indexPath)
    switch row {
    case .all:
      return selectedMember.isEmpty ? .checkmark : .none
    case .member(let userProfile, _):
      return isSelected(member: userProfile) ? .checkmark : .none
    }
  }
  
  // MARK: Selection
  func isSelected(member: UserProfile) -> Bool {
    return selectedMember.contains(member)
  }
  
  func toggleSelected(member: UserProfile) {
    if let index = selectedMember.firstIndex(of: member) {
      selectedMember.remove(at: index)
    } else {
      selectedMember.append(member)
    }
  }
  
  func deselectAllMember() {
    selectedMember.removeAll()
  }
}

// MARK: Apis
extension DefaultAddMonthlyFeeViewModel {
  func getAllMembers() {
    indicateLoading()
    userSessionRepository.getAllMembers()
      .done(indicateGetMemberSuccess(members:))
      .catch(indicateError(error:))
  }
  
  func addMonthlyFee() {
    indicateLoading()
    
    let targetUser: [UserProfile] = selectedMember.isEmpty ? allMembers : selectedMember
    
    targetUser.forEach { (userProfile) in
      dispatchGroup.enter()
      
      userSessionRepository.addMonthlyFeeLog(admin: userSession.profile, user: userProfile, amount: monthAmountInput.value)
        .done { [weak self] in self?.indicateAddMonthlyFeeSuccess() }
      .catch(indicateError(error: ))
    }
    
    dispatchGroup.notify(queue: .main) { [weak self] in
      guard let this = self else { return }
      
      if this.addMonthlyFeeErrorHasError {
        this.addMonthlyFeeErrorHasError = false
        this._apiState.accept(.error(HSError.unknown))
      } else {
        this._apiState.accept(.completed)
      }
      
    }
  }
  
  private func indicateLoading() {
    _apiState.accept(.loading)
  }
  
  private func indicateAddMonthlyFeeSuccess() {
    dispatchGroup.leave()
  }
  
  private func indicateGetMemberSuccess(members: [UserProfile]) {
    allMembers = members
    _apiState.accept(.completed)
  }
  
  private func indicateAddMonthlyFeeError(error: Error) {
    addMonthlyFeeErrorHasError = true
    dispatchGroup.leave()
  }
  
  private func indicateError(error: Error) {
    _apiState.accept(.error(error))
  }
}

