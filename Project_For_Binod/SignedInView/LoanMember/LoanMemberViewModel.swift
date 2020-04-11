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
    var selectedMember: BehaviorRelay<UserProfile> { get }
    var isLoanMemberButtonEnabled: Observable<Bool> { get }
    
    var apiState: Driver<State> { get }
    var loanMemberSuccessful: Driver<Bool> { get }
    
    func getAllMembers()
    func loanMember()
    
    func numberOfRows() -> Int
    func viewModelForRow(at indexPath: IndexPath) -> MemberCellViewModel
}

struct LoanMemberViewModel: LoanMemberViewModelProtocol {
    
}
