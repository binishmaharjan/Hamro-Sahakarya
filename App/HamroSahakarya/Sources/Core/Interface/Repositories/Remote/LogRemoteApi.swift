import Foundation
import PromiseKit

public protocol LogRemoteApi {
    func getLogs() -> Promise<[GroupLog]>
    func fetchLogsFromLastSnapshot() -> Promise<[GroupLog]>
    func addJoinedLog(userSession: UserSession) -> Promise<UserSession>
    func addMonthlyFeeLog(admin: UserProfile, userProfile: UserProfile, amount: Int) -> Promise<Void>
    func addExtraOrExpensesLog(type: ExtraOrExpenses, admin: UserProfile, amount: Int, reason: String) -> Promise<Void>
    func addAmountOrDeductAmountLog(type: AddOrDeduct ,admin: UserProfile, member: UserProfile, amount: Int) -> Promise<Void>
    func addLoanMemberLog(admin: UserProfile, member: UserProfile, amount: Int) -> Promise<Void>
    func addLoanReturnedLog(admin: UserProfile, member: UserProfile, amount: Int) -> Promise<Void>
    func addRemoveMemberLog(admin: UserProfile, member: UserProfile) -> Promise<Void>


}
