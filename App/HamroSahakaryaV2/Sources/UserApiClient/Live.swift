import Foundation
import SwiftUI
import Dependencies
import SharedModels
import UserAuthClient
import UserDataClient
import UserDefaultsClient
import UserLogClient
import UserStorageClient

// MARK: - Live Implementation
extension UserApiClient {
    public static func live() -> UserApiClient {
        let session = Session()
        
        return UserApiClient(
            signIn:  { try await session.signIn(email: $0, password: $1) },
            createUser:  { try await session.createUser(newAccount: $0) },
            signOut:  { try await session.signOut(account: $0) },
            removeMember:  { try await session.removeMember(admin: $0, user: $1) },
            getLogs:  { try await session.getLogs() },
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
            updateNotice:  { try await session.updateNotice(admin: $0, notice: $1) },
            downloadTermsAndCondition:  { try await session.downloadTermsAndCondition() }
        )
    }
}

extension UserApiClient {
    actor Session {
        func signIn(email: Email, password: Password) async throws -> Account {
            fatalError()
        }
        
        func createUser(newAccount: NewAccount) async throws -> Account {
            fatalError()
        }
        
        func signOut(account: Account) async throws -> Void {
            fatalError()
        }
        
        func removeMember(admin: Account, user: Account) async throws -> Void {
            fatalError()
        }
        
        func getLogs() async throws -> [GroupLog] {
            fatalError()
        }
        
        func addMonthlyFeeLog(admin: Account, user: Account, balance: Balance) async throws -> Void {
            fatalError()
        }
        
        func addExtraAndExpenses(admin: Account, type: ExtraOrExpenses, balance: Balance, reason: String) async throws -> Void {
            fatalError()
        }
        
        func addOrDeductAmount(admin: Account, user: Account, type: AddOrDeduct, balance: Balance) async throws -> Void {
            fatalError()
        }
        
        func fetchGroupDetail() async throws -> GroupDetail {
            fatalError()
        }
        
        func loanMember(admin: Account, user: Account, loan: Loan) async throws -> Void {
            fatalError()
        }
        
        func loanReturned(admin: Account, user: Account, loan: Loan) async throws -> Void {
            fatalError()
        }
        
        func changeProfileImage(user: Account, image: Image) async throws -> Void {
            fatalError()
        }
        
        func changePassword(user: Account, newPassword: Password) async throws -> Void {
            fatalError()
        }
        
        func changeStatus(for user: Account) async throws -> Void {
            fatalError()
        }
        
        func fetchAllMembers() async throws -> [Account] {
            fatalError()
        }
        
        func fetchAllMembersWithLoan() async throws -> [Account] {
            fatalError()
        }
        
        func fetchNotice() async throws -> Notice {
            fatalError()
        }
        
        func updateNotice(admin: Account, notice: Notice) async throws -> Void {
            fatalError()
        }
        
        func downloadTermsAndCondition() async throws -> Data {
            fatalError()
        }
    }
}
