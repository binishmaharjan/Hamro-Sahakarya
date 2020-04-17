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
    
}
