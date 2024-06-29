import Foundation
import UIKit
import Dependencies
import SharedModels
import UserAuthClient
import UserDataClient
import UserDefaultsClient
import UserLogClient
import UserStorageClient

// MARK: Dependency (liveValue)
extension UserApiClient: DependencyKey {
    public static let liveValue = UserApiClient.live()
}

// MARK: - Live Implementation
extension UserApiClient {
    public static func live() -> UserApiClient {
        let session = Session()
        
        return UserApiClient(
            signIn:  { try await session.signIn(email: $0, password: $1) },
            createUser:  { try await session.createUser(newUser: $0) },
            sendPasswordReset: { try await session.sendPasswordReset(email: $0) },
            signOut:  { try await session.signOut() },
            removeMember:  { try await session.removeMember(admin: $0, user: $1) },
            fetchLogs:  { try await session.fetchLogs() },
            addMonthlyFee:  { try await session.addMonthlyFee(admin: $0, user: $1, balance: $2) },
            addExtraAndExpenses:  { try await session.addExtraAndExpenses(type: $0, admin: $1, balance: $2, reason: $3) },
            addOrDeductAmount:  { try await session.addOrDeductAmount(type: $0, admin: $1, user: $2, balance: $3) },
            fetchGroupDetail:  { try await session.fetchGroupDetail() },
            loanGiven:  { try await session.loanGiven(admin: $0, user: $1, loan: $2) },
            loanReturned:  { try await session.loanReturned(admin: $0, user: $1, loan: $2) },
            changeProfileImage:  { try await session.changeProfileImage(user: $0, image: $1) },
            changePassword:  { try await session.changePassword(user: $0, newPassword: $1) },
            changeStatus:  { try await session.changeStatus(for: $0) },
            fetchAllMembers:  { try await session.fetchAllMembers() },
            fetchAllMembersWithLoan:  { try await session.fetchAllMembersWithLoan() },
            fetchNotice:  { try await session.fetchNotice() },
            updateNotice:  { try await session.updateNotice(admin: $0, message: $1) },
            downloadTermsAndCondition:  { try await session.downloadTermsAndCondition() }
        )
    }
}

extension UserApiClient {
    actor Session {
        @Dependency(\.userAuthClient) var userAuthClient
        @Dependency(\.userLogClient) var userLogClient
        @Dependency(\.userDataClient) var userDataClient
        @Dependency(\.userStorageClient) var userStorageClient
        @Dependency(\.userDefaultsClient) var userDefaultsClient
        
        func signIn(email: Email, password: Password) async throws -> User {
            let uuid = try await userAuthClient.signIn(withEmail: email, password: password)
            let user = try await userDataClient.fetch(by: uuid)
            
            userDefaultsClient.saveUser(user)
            
            return user
        }
        
        func createUser(newUser: NewUser) async throws -> User {
            let uuid = try await userAuthClient.createUser(withUser: newUser)
            let user = newUser.createAccount(with: uuid)
            
            try await userDataClient.save(user)
            try await userLogClient.addJoinedLog(for: user)
            
            userDefaultsClient.saveUser(user)
            
            return user
        }
        
        func sendPasswordReset(email: Email) async throws -> Void {
            try await userAuthClient.sendPasswordReset(withEmail: email)
        }
        
        func signOut() async throws -> Void {
            try await userAuthClient.signOut()
            
            userDefaultsClient.deleteUser()
        }
        
        func removeMember(admin: User, user: User) async throws -> Void {
            try await userDataClient.remove(user)
            try await userLogClient.addRemoveMemberLog(by: admin, user: user)
        }
        
        func fetchLogs() async throws -> [GroupLog] {
            try await userLogClient.fetchLogs()
        }
        
        func addMonthlyFee(admin: User, user: User, balance: Balance) async throws -> Void {
            try await userDataClient.addMonthlyFee(for: user, balance: balance)
            try await userLogClient.addMonthlyFeeLog(by: admin, user: user, balance: balance)
        }
        
        func addExtraAndExpenses(type: ExtraOrExpenses, admin: User, balance: Balance, reason: String) async throws -> Void {
            let extra = (type == .extra) ? balance : 0
            let expenses = (type == .extra) ? 0 : balance
            let groupDetail = try await userDataClient.fetchGroupDetail()
            
            try await userDataClient.updateExtraAndExpenses(with: groupDetail, extra: extra, expenses: expenses)
            try await userLogClient.addExtraOrExpensesLog(for: type, admin: admin, balance: balance, reason: reason)
        }
        
        func addOrDeductAmount(type: AddOrDeduct, admin: User, user: User, balance: Balance) async throws -> Void {
            let newBalance = (type == .add) ? (user.balance + balance) : (user.balance - balance)

            try await userDataClient.updateAmount(for: user, balance: newBalance)
            try await userLogClient.addAmountOrDeductAmountLog(for: type, admin: admin, user: user, balance: balance)
        }
        
        func fetchGroupDetail() async throws -> GroupDetail {
            try await userDataClient.fetchGroupDetail()
        }
        
        func loanGiven(admin: User, user: User, loan: Loan) async throws -> Void {
            try await userDataClient.loanGiven(to: user, loan: loan)
            try await userLogClient.addLoanMemberLog(by: admin, user: user, loan: loan)
        }
        
        func loanReturned(admin: User, user: User, loan: Loan) async throws -> Void {
            try await userDataClient.loanReturned(by: user, loan: loan)
            try await userLogClient.addLoanReturnedLog(by: admin, user: user, loan: loan)
        }
        
        func changeProfileImage(user: User, image: UIImage) async throws -> Void {
            let imageUrl = try await userStorageClient.saveImage(for: user, image: image)
            try await userDataClient.updateImageUrl(for: user, imageUrl: imageUrl.absoluteString)
            
            let updatedUser = try await userDataClient.fetch(by: user.id)
            userDefaultsClient.saveUser(updatedUser)
        }
        
        func changePassword(user: User, newPassword: Password) async throws -> Void {
            try await userAuthClient.changePassword(to: newPassword)
            try await userDataClient.changePassword(for: user, newPassword: newPassword)
        }
        
        func changeStatus(for user: User) async throws -> Void {
            try await userDataClient.changeStatus(for: user)
        }
        
        func fetchAllMembers() async throws -> [User] {
            try await userDataClient.fetchAllMembers()
        }
        
        func fetchAllMembersWithLoan() async throws -> [User] {
            try await userDataClient.fetchAllMembersWithLoan()
        }
        
        func fetchNotice() async throws -> NoticeInfo {
            try await userDataClient.fetchNotice()
        }
        
        func updateNotice(admin: User, message: String) async throws -> Void {
            try await userDataClient.updateNotice(by: admin, message: message)
        }
        
        func downloadTermsAndCondition() async throws -> Data {
            try await userStorageClient.downloadTermsAndCondition()
        }
    }
}
