//
//  AddOrDeductAmountViewModel.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/05/17.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

enum AddOrDeduct: String, CaseIterable {
    case add = "Add Amount"
    case deduct = "Deduct Amount"
}

protocol AddOrDeductStateProtocol {
    var selectedUser: UserProfile? { get }
    var amount: Int { get }
}

extension AddOrDeductStateProtocol {
    var isConfirmButtonEnabled: Bool {
        return selectedUser != nil && amount > 0
    }
}

protocol AddOrDeductAmountViewModelProtocol {
    var selectedTypeInput: BehaviorRelay<AddOrDeduct> { get }
    var selectedUser: BehaviorRelay<UserProfile?> { get }
    var amountInput: BehaviorRelay<Int> { get }
    
    var isConfirmButtonEnabled: Observable<Bool> { get }
    var apiState: Driver<State> { get }
    
    func addorDeduct()
    func fetchAllMembers()
    func numberOfRows() -> Int
    func viewModelForRow(at indexPath: IndexPath) -> MemberCellViewModel
    func userProfileForRow(at indexPath: IndexPath) -> UserProfile
    func isUserSelected(userProfile: UserProfile) -> Bool
}

struct AddOrDeductAmountViewModel: AddOrDeductAmountViewModelProtocol {

    struct UIState: AddOrDeductStateProtocol {
        var selectedUser: UserProfile?
        var amount: Int
    }
    
    private var allMembers: BehaviorRelay<[UserProfile]> = BehaviorRelay(value: [])
    private let userSessionRepository: UserSessionRepository
    private let userSession: UserSession
    
    var selectedTypeInput: BehaviorRelay<AddOrDeduct> = BehaviorRelay(value: .add)
    var selectedUser: BehaviorRelay<UserProfile?> = BehaviorRelay(value: nil)
    var amountInput: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var isConfirmButtonEnabled: Observable<Bool>
    
    @PropertyBehaviourRelay<State>(value: .idle)
    var apiState: Driver<State>
    @PropertyBehaviourRelay<Bool>(value: false)
    var addOrDeductSuccessful: Driver<Bool>
    
    init(userSessionRepository: UserSessionRepository, userSession: UserSession) {
        self.userSessionRepository = userSessionRepository
        self.userSession = userSession
        
        let state = Observable.combineLatest(selectedUser, amountInput) { UIState(selectedUser: $0, amount: $1) }
        isConfirmButtonEnabled = state.map { $0.isConfirmButtonEnabled }
    }
    
    func numberOfRows() -> Int {
        return allMembers.value.count
    }
    
    func viewModelForRow(at indexPath: IndexPath) -> MemberCellViewModel {
        let member = userProfileForRow(at: indexPath)
        return DefaultMemberCellViewModel(profile: member)
    }
    
    func userProfileForRow(at indexPath: IndexPath) -> UserProfile {
        return allMembers.value[indexPath.row]
    }
    
    func isUserSelected(userProfile: UserProfile) -> Bool {
        guard let selectedMember = selectedUser.value else { return false }
        
        return userProfile == selectedMember
    }
}

// MARK: Api
extension AddOrDeductAmountViewModel {
    
    func addorDeduct() {
        guard let selectedUser = selectedUser.value else { return }
        userSessionRepository
            .addOrDeductAmount(admin: userSession.profile.value, member: selectedUser, type: selectedTypeInput.value, amount: amountInput.value)
            .done{ self.indicateAddOrDeductSuccessful() }
            .catch(indicateError(error:))
    }
    
    func fetchAllMembers() {
        indicateLoading()
        
        userSessionRepository
            .getAllMembers()
            .done(indicateFetchAllMemberSuccessful(members:))
            .catch(indicateError(error:))
    }
    
    private func indicateLoading() {
        _addOrDeductSuccessful.accept(false)
        _apiState.accept(.loading)
    }
    
    private func indicateAddOrDeductSuccessful() {
        _addOrDeductSuccessful.accept(true)
        selectedUser.accept(nil)
        _apiState.accept(.completed)
    }
    
    private func indicateFetchAllMemberSuccessful(members: [UserProfile]) {
        allMembers.accept(members)
        _apiState.accept(.completed)
    }
    
    private func indicateError(error: Error) {
        _apiState.accept(.error(error))
    }
}
