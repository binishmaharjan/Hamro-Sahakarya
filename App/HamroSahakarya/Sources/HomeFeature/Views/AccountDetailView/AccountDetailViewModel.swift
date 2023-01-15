import Core
import Foundation
import RxSwift
import UIKit

public protocol AccountDetailViewModelProtocol {
    var currentBalance: Observable<Int> { get }
    var totalCollection: Observable<Int> { get }
    var extraIncome: Observable<Int> { get }
    var expenses: Observable<Int> { get }
    var totalLoanGiven: Observable<Int> { get }
    var profit: Observable<Int> { get }
    var profitDisplayText: Observable<String> { get }
    var shouldHideExtraInfo: Observable<Bool> { get }
    var profitLabelColor: Observable<UIColor> { get }
}

public struct AccountDetailViewModel: AccountDetailViewModelProtocol {
    private let allMembers: Observable<[UserProfile]>
    private let groupDetail: Observable<GroupDetail>
    
    public var currentBalance: Observable<Int>
    public var totalCollection: Observable<Int>
    public var extraIncome: Observable<Int>
    public var expenses: Observable<Int>
    public var totalLoanGiven: Observable<Int>
    public var profit: Observable<Int>
    public var shouldHideExtraInfo: Observable<Bool>
    public var profitLabelColor: Observable<UIColor>
    public var profitDisplayText: Observable<String>
    
    public init(
        allMembers: Observable<[UserProfile]>,
        groupDetail: Observable<GroupDetail>,
        isAdmin: Observable<Bool>
    ) {
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
        
        profit = Observable.combineLatest(extraIncome, expenses) {
            return ($0 - $1)
        }
        profitDisplayText = profit.map { ($0 > 0) ? "Profit" : "Loss" }
        
        profitLabelColor = profit.map { ($0 > 0) ? UIColor.systemGreen : UIColor.mainBlack }
        
        shouldHideExtraInfo = isAdmin.map { !$0 }
    }
}
