//
//  ExtraAndExpensesViewModel.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/04/08.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum ExtraOrExpenses: String, CaseIterable {
    case extra = "Extra Income"
    case expenses = "Expenses"
}

protocol ExtraAndExpensesStateProtocol {
    var amount: Int { get }
    var reason: String { get }
}

extension ExtraAndExpensesStateProtocol {
    var isConfirmButtonEnabled: Bool {
        return amount > 0 && reason.isNotEmpty()
    }
}

protocol ExtranAndExpensesViewModelProtocol {
    var selectedTypeInput: BehaviorRelay<ExtraOrExpenses> { get }
    var amountInput: BehaviorRelay<Int> { get }
    var reasonInput: BehaviorRelay<String> { get }
    var isConfirmButtonEnabled: Observable<Bool> { get }
    
    var apiState: Driver<State> { get }
    
    func updateExtraOrExpenses()
}

struct ExtraAndExpensesViewModel: ExtranAndExpensesViewModelProtocol {
    
    struct UIState: ExtraAndExpensesStateProtocol {
        
        var amount: Int
        var reason: String
    }
    
    private var userSessionRepository: UserSessionRepository
    private var userSession: UserSession
    
    var selectedTypeInput: BehaviorRelay<ExtraOrExpenses> = BehaviorRelay(value: .extra)
    var amountInput: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var reasonInput: BehaviorRelay<String> = BehaviorRelay(value: "")
    var isConfirmButtonEnabled: Observable<Bool>
    
    @PropertyBehaviourRelay<State>(value: .idle)
    var apiState: Driver<State>
    
    init(userSessionRepository: UserSessionRepository, userSession: UserSession) {
        self.userSessionRepository = userSessionRepository
        self.userSession = userSession
        
        let state = Observable.combineLatest(amountInput,reasonInput).map { UIState(amount: $0, reason: $1) }
        isConfirmButtonEnabled = state.map { $0.isConfirmButtonEnabled }
    }
    
    
    func updateExtraOrExpenses() {
        indicateLoading()
        
        userSessionRepository
            .updateExtraAndExpenses(admin: userSession.profile.value, type: selectedTypeInput.value, amount: amountInput.value, reason: reasonInput.value)
            .done{ self.indicateSuccess() }
            .catch(indicateError(error:))
    }
}

// MARK: Indication
extension ExtraAndExpensesViewModel {
    
    private func indicateLoading() {
        _apiState.accept(.loading)
    }
    
    private func indicateSuccess() {
        _apiState.accept(.completed)
    }
    
    private func indicateError(error: Error) {
        _apiState.accept(.error(error))
    }
}
