import Foundation
import PromiseKit
import UIKit

public protocol UserSessionRepository {

    func readUserSession() -> Promise<UserSession?>
    func saveUserSession(userProfile: UserProfile) -> Promise<UserSession>
    func signUp(newAccount: NewAccount) -> Promise<UserSession>
    func signIn(email: String, password: String) -> Promise<UserSession>
    func signOut(userSession: UserSession) -> Promise<UserSession>
    func removeMember(admin: UserProfile, member: UserProfile) -> Promise<Void>

    func getLogs() -> Promise<[GroupLog]>
    func fetchMoreLogsFromLastSnapShot() -> Promise<[GroupLog]>
    func addMonthlyFeeLog(admin: UserProfile, user: UserProfile, amount: Int) -> Promise<Void>
    func updateExtraAndExpenses(admin: UserProfile, type: ExtraOrExpenses, amount: Int, reason: String) -> Promise<Void>
    func addOrDeductAmount(admin: UserProfile, member: UserProfile, type: AddOrDeduct, amount: Int) -> Promise<Void>
    func fetchExtraAndExpenses() -> Promise<GroupDetail>
    func loanMember(admin: UserProfile, member: UserProfile, amount: Int) -> Promise<Void>
    func loanReturned(admin: UserProfile, member: UserProfile, amount: Int) ->Promise<Void>

    func changeProfilePicture(userSession: UserSession, image: UIImage) -> Promise<UserSession>
    func changePassword(userSession: UserSession, newPassword: String) -> Promise<String>
    func changeStatus(for user: UserProfile) -> Promise<Void>
    func getAllMembers() -> Promise<[UserProfile]>
    func getAllMembersWithLoan() -> Promise<[UserProfile]>

    func fetchNotice() -> Promise<Notice>
    func updateNotice(userProfile: UserProfile, notice: String) -> Promise<Void>
    func downloadTermsAndCondition() -> Promise<Data>
}
