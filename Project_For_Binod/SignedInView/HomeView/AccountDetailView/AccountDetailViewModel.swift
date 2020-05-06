//
//  AccountDetailViewModel.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/05/06.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation
import RxSwift

protocol AccountDetailViewModelProtocol {
    var currentBalance: Observable<Int> { get }
    var totalCollection: Observable<Int> { get }
    var extraIncome: Observable<Int> { get }
    var expenses: Observable<Int> { get }
    var totalLoanGiven: Observable<Int> { get }
}

struct AccountDetailViewModel: AccountDetailViewModelProtocol {
    private let allMembers: Observable<[UserProfile]>
    private let groupDetail: Observable<GroupDetail>
    
    var currentBalance: Observable<Int>
    var totalCollection: Observable<Int>
    var extraIncome: Observable<Int>
    var expenses: Observable<Int>
    var totalLoanGiven: Observable<Int>
    
    init(allMembers: Observable<[UserProfile]>, groupDetail: Observable<GroupDetail>) {
        self.allMembers = allMembers
        self.groupDetail = groupDetail
        
        totalCollection = allMembers.map { (allMembers) -> Int in
            var totalCollection: Int = 0
            
            allMembers.forEach { (member) in
                totalCollection += member.balance
            }
            
            return totalCollection
        }
        
        totalLoanGiven = allMembers.map { (allMembers) -> Int in
            var loanTaken: Int = 0
            
            allMembers.forEach { (member) in
                loanTaken += member.loanTaken
            }
            
            return loanTaken
        }
        
        extraIncome = groupDetail.map { $0.extra }
        expenses = groupDetail.map { $0.expenses }
        currentBalance = Observable.combineLatest(totalCollection, totalLoanGiven, extraIncome, expenses) {
            return ($0 + $2 - $1 - $3)
        }

    }
}
