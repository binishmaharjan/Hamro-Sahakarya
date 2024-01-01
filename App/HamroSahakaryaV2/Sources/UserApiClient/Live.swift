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
            addMonthlyFeeLog:  { try await session.addMonthlyFeeLog(admin: $0, user: $1, balance: $2) },
            addExtraAndExpenses:  { try await session.addExtraAndExpenses(admin: $0, type: $1, balance: $2, reason: $3) },
            addOrDeductAmount:  { try await session.addOrDeductAmount(admin: $0, user: $1, type: $2, balance: $3) },
            fetchGroupDetail:  { try await session.fetchGroupDetail() },
            loanMember:  { try await session.loanMember(admin: $0, user: $1, loan: $2) },
            loanReturned:  { try await session.loanReturned(admin: $0, user: $1, loan: $2) },
            changeProfileImage:  { try await session.changeProfileImage(user: $0, image: $1) },
            changePassword:  { try await session.changePassword(user: $0, newPassword: $1) },
            changeStatusForUser:  { try await session.changeStatus(for: $0) },
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
            let uuid = try await userAuthClient.signIn(email, password)
            let user = try await userDataClient.fetch(uuid)
            
            userDefaultsClient.saveUser(user)
            
            return user
        }
        
        func createUser(newUser: NewUser) async throws -> User {
            let uuid = try await userAuthClient.createUser(newUser)
            let user = newUser.createAccount(with: uuid)
            
            try await userDataClient.save(user)
            try await userLogClient.addJoinedLog(user)
            
            userDefaultsClient.saveUser(user)
            
            return user
        }
        
        func sendPasswordReset(email: Email) async throws -> Void {
            try await userAuthClient.sendPasswordReset(email)
        }
        
        func signOut() async throws -> Void {
            try await userAuthClient.signOut()
            
            userDefaultsClient.deleteUser()
        }
        
        func removeMember(admin: User, user: User) async throws -> Void {
            try await userDataClient.remove(user)
            try await userLogClient.addRemoveMemberLog(admin, user)
        }
        
        func fetchLogs() async throws -> [GroupLog] {
            try await userLogClient.fetchLogs()
        }
        
        func addMonthlyFeeLog(admin: User, user: User, balance: Balance) async throws -> Void {
            try await userDataClient.addMonthlyFeeFor(user, balance)
            try await userLogClient.addMonthlyFeeLog(admin, user, balance)
        }
        
        func addExtraAndExpenses(admin: User, type: ExtraOrExpenses, balance: Balance, reason: String) async throws -> Void {
            let extra = (type == .extra) ? balance : 0
            let expenses = (type == .extra) ? 0 : balance
            let groupDetail = try await userDataClient.fetchGroupDetail()
            
            try await userDataClient.updateExtraAndExpenses(groupDetail, extra, extra)
            try await userLogClient.addExtraOrExpensesLog(type, admin, balance, reason)
        }
        
        func addOrDeductAmount(admin: User, user: User, type: AddOrDeduct, balance: Balance) async throws -> Void {
            let newBalance = (type == .add) ? (user.balance + balance) : (user.balance - balance)

            try await userDataClient.updateAmountFor(user, newBalance)
            try await userLogClient.addAmountOrDeductAmountLog(type, admin, user, balance)
        }
        
        func fetchGroupDetail() async throws -> GroupDetail {
            try await userDataClient.fetchGroupDetail()
        }
        
        func loanMember(admin: User, user: User, loan: Loan) async throws -> Void {
            try await userDataClient.loanMember(user, loan)
            try await userLogClient.addLoanMemberLog(admin, user, loan)
        }
        
        func loanReturned(admin: User, user: User, loan: Loan) async throws -> Void {
            try await userDataClient.loanReturned(user, loan)
            try await userLogClient.addLoanReturnedLog(admin, user, loan)
        }
        
        func changeProfileImage(user: User, image: UIImage) async throws -> Void {
            let imageUrl = try await userStorageClient.saveImage(user, image)
            try await userDataClient.updateImageUrl(user, imageUrl.absoluteString)
            
            let updatedUser = try await userDataClient.fetch(user.id)
            userDefaultsClient.saveUser(updatedUser)
        }
        
        func changePassword(user: User, newPassword: Password) async throws -> Void {
            try await userAuthClient.changePassword(newPassword)
            try await userDataClient.changePassword(user, newPassword)
        }
        
        func changeStatus(for user: User) async throws -> Void {
            try await userDataClient.changeStatusForUser(user)
        }
        
        func fetchAllMembers() async throws -> [User] {
            try await userDataClient.fetchAllMembers()
        }
        
        func fetchAllMembersWithLoan() async throws -> [User] {
            try await userDataClient.fetchAllMembersWithLoan()
        }
        
        func fetchNotice() async throws -> Notice {
            try await userDataClient.fetchNotice()
        }
        
        func updateNotice(admin: User, message: String) async throws -> Void {
            try await userDataClient.updateNotice(admin, message)
        }
        
        func downloadTermsAndCondition() async throws -> Data {
            try await userStorageClient.downloadTermsAndCondition()
        }
    }
}
