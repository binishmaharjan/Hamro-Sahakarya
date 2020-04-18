//
//  LoanReturnedViewModel.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/04/17.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol LoanReturnedUIStateProtocol {
    var selectedMember: UserProfile? { get }
    var returnedAmount: Int { get }
}

extension LoanReturnedUIStateProtocol {
     
    var isReturnAmountButtonEnabled: Bool {
        return selectedMember != nil && returnedAmount > 0
    }
}

protocol LoanReturnedViewModelProtocol {
    var returnedAmount: BehaviorRelay<Int> { get }
      var selectedMember: BehaviorRelay<UserProfile?> { get }
      var isReturnAmountButtonEnabled: Observable<Bool> { get }
      
      var apiState: Driver<State> { get }
      var returnedAmountSuccessful: Driver<Bool> { get }
      
      func getAllMembers()
      func returnAmount()
      
      func numberOfRows() -> Int
      func viewModelForRow(at indexPath: IndexPath) -> MemberCellViewModel
      func userProfileForRow(at indexPath: IndexPath) -> UserProfile
      func isUserSelected(userProfile: UserProfile) -> Bool
}

struct LoanReturnedViewModel: LoanReturnedViewModelProtocol {
    
    struct UIState: LoanReturnedUIStateProtocol {
    
        var selectedMember: UserProfile?
        var returnedAmount: Int
    }
    
    private let userSessionRepository: UserSessionRepository
    private let userSession: UserSession
    private let allMembers: BehaviorRelay<[UserProfile]> = BehaviorRelay(value: [])
    
    var returnedAmount: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var selectedMember: BehaviorRelay<UserProfile?> = BehaviorRelay(value: nil)
    var isReturnAmountButtonEnabled: Observable<Bool>
    
    @PropertyBehaviourRelay<State>(value: .idle)
    var apiState: Driver<State>
    @PropertyBehaviourRelay<Bool>(value: false)
    var returnedAmountSuccessful: Driver<Bool>
    
    init(userSessionRepository: UserSessionRepository, userSession: UserSession) {
        self.userSessionRepository = userSessionRepository
        self.userSession = userSession
        
        let state = Observable.combineLatest(selectedMember, returnedAmount)
            .map { UIState(selectedMember: $0, returnedAmount: $1) }
        self.isReturnAmountButtonEnabled = state.map { $0.isReturnAmountButtonEnabled }
    }
    
    
    func numberOfRows() -> Int {
        allMembers.value.count
    }
    
    func viewModelForRow(at indexPath: IndexPath) -> MemberCellViewModel {
        return DefaultMemberCellViewModel(profile: userProfileForRow(at: indexPath))
    }
    
    func userProfileForRow(at indexPath: IndexPath) -> UserProfile {
        return allMembers.value[indexPath.row]
    }
    
    func isUserSelected(userProfile: UserProfile) -> Bool {
        guard let selectedMember = selectedMember.value else { return false }
        
        return userProfile == selectedMember
    }
}

extension LoanReturnedViewModel {
    
    func returnAmount() {
        
    }
    
    func getAllMembers() {
        
    }
    
  
}
