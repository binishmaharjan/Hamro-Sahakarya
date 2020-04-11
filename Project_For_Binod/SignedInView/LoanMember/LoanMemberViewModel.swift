//
//  LoanMemberViewModel.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/04/11.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol LoanMemberStateProtocol {
    var selectedMember: UserProfile? { get }
    var loanAmount: Int { get }
}

extension LoanMemberStateProtocol {
    
    var isLoanMemberButtonEnabled: Bool {
        guard selectedMember.exists else { return false }
        return loanAmount > 0
    }
}

protocol LoanMemberViewModelProtocol {
    var loanAmount: BehaviorRelay<Int> { get }
    var selectedMember: BehaviorRelay<UserProfile?> { get }
    var isLoanMemberButtonEnabled: Observable<Bool> { get }
    
    var apiState: Driver<State> { get }
    var loanMemberSuccessful: Driver<Bool> { get }
    
    func getAllMembers()
    func loanMember()
    
    func numberOfRows() -> Int
    func viewModelForRow(at indexPath: IndexPath) -> MemberCellViewModel
}

struct LoanMemberViewModel: LoanMemberViewModelProtocol {
    
    struct UIState: LoanMemberStateProtocol {
        
        var selectedMember: UserProfile?
        var loanAmount: Int
    }
    
    private var allMembers: BehaviorRelay<[UserProfile]> = BehaviorRelay(value: [])
    private var userSessionRepository: UserSessionRepository
    private var userSession: UserSession
    
    var loanAmount: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var selectedMember: BehaviorRelay<UserProfile?> = BehaviorRelay(value: nil)
    var isLoanMemberButtonEnabled: Observable<Bool>
    
    @PropertyBehaviourRelay<State>(value: .idle)
    var apiState: Driver<State>
    @PropertyBehaviourRelay<Bool>(value: false)
    var loanMemberSuccessful: Driver<Bool>
    
    init(userSessionRepository: UserSessionRepository, userSession: UserSession) {
        self.userSessionRepository = userSessionRepository
        self.userSession = userSession
        
        let state = Observable.combineLatest(selectedMember,loanAmount).map { UIState(selectedMember: $0, loanAmount: $1) }
        isLoanMemberButtonEnabled = state.map { $0.isLoanMemberButtonEnabled }
    }
    
    func numberOfRows() -> Int {
       fatalError()
    }
    
    func viewModelForRow(at indexPath: IndexPath) -> MemberCellViewModel {
        fatalError()
    }
    
    func getAllMembers() {
        
    }
    
    func loanMember() {
        
    }
    
}
