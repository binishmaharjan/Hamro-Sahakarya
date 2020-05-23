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
}

// MARK: Api
extension AddOrDeductAmountViewModel {
    
    func addorDeduct() {
        
    }
    
    private func inidicateLoading() {
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
