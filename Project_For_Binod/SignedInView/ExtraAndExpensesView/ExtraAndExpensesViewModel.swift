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

enum ExtraOrExpenses {
    case extra
    case expenses
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
    var resonInput: BehaviorRelay<String> { get }
    var isConfirmButtonEnabled: Observable<Bool> { get }
    
    var apiState: Driver<State> { get }
    
    func addExtraOrExpenses()
}

struct ExtraAndExpensesViewModel {
    
}
