//
//  MembersViewModel.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/02/29.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol MembersViewModel {
  
  var count: Int { get }
  var apiState: Driver<State> { get }
  
  func viewModelForRow(at indexPath: IndexPath) -> MemberCellViewModel
  func getAllMembers()
}

final class DefaultMembersViewModel: MembersViewModel {
  
  // MARK: Properties
  private var profiles: [UserProfile] = []
  private let userSessionRepository: UserSessionRepository
  @PropertyBehaviourRelay<State>(value: .idle)
  var apiState: Driver<State>
  
  var count: Int {
    return profiles.count
  }
  
  init(userSessionRepository: UserSessionRepository) {
    self.userSessionRepository = userSessionRepository
  }
  
  // MARK: Methods
  func viewModelForRow(at indexPath: IndexPath) -> MemberCellViewModel {
    return DefaultMemberCellViewModel(profile: profiles[indexPath.row])
  }
  
  func getAllMembers() {
    indicateLoading()
    userSessionRepository.getAllMembers()
      .done(indicateLoadSuccessful(profiles:))
      .catch(indicateError(error:))
  }
}

// MARK: Indication
extension DefaultMembersViewModel {
  private func indicateLoading() {
    _apiState.accept(.loading)
  }
  
  private func indicateLoadSuccessful(profiles: [UserProfile]) {
    self.profiles = profiles
    _apiState.accept(.completed)
  }
  
  private func indicateError(error: Error) {
    _apiState.accept(.error(error))
  }
}
