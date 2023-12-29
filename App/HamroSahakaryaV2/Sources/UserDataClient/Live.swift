import Foundation
import Dependencies
import SharedModels
import FirebaseAuth

// MARK: Dependency (liveValue)
extension UserDataClient: DependencyKey {
    public static let liveValue = UserDataClient.live()
}

// MARK: - Live Implementation
extension UserDataClient {
    public static func live() -> UserDataClient {
        let session = Session()
        
        return UserDataClient(
            fetch: { try await session.fetch(accountId: $0) },
            save: { try await session.save(account: $0) },
            remove: { try await session.remove(account: $0) },
            updateImageUrl: { try await session.updateImageUrl(account: $0, imageUrl: $1) },
            updatePassword: { try await session.updatePassword(account: $0, password: $1) },
            fetchAllMembers: { try await session.fetchAllMembers() },
            fetchAllMembersWithLoan: { try await session.fetchAllMemberWithLoan() },
            changeStatusForUser: { try await session.changeStatusForUser(account: $0) },
            addMonthlyFeeFor: { try await session.addMonthlyFeeFor(account: $0, balance: $1) },
            loanMember: { try await session.loanMember(account: $0, loan: $1) },
            loanReturned: { try await session.loanReturned(account: $0, loan: $1) },
            updateExtraAndExpenses: { try await session.updateExtraAndExpenses(groupDetail: $0, extra: $1, expenses: $2) },
            updateAmountFor: { try await session.updateAmountFor(account: $0, balance: $1) },
            fetchGroupDetail: { try await session.fetchGroupDetail() },
            fetchNotice: { try await session.fetchNotice() },
            updateNotice: { try await session.updateNotice(account: $0, notice: $1) }
        )
    }
}

extension UserDataClient {
    actor Session {
        func fetch (accountId: AccountId) async throws -> Account {
            fatalError()
        }
        
        func save(account: Account) async throws -> Void {
            fatalError()
        }
        
        func remove(account: Account) async throws -> Void {
            fatalError()
        }
        
        func updateImageUrl(account: Account, imageUrl: ImageUrl) async throws -> Void {
            fatalError()
        }
        
        func updatePassword(account: Account, password: Password) async throws -> Void {
            fatalError()
        }
        
        func fetchAllMembers() async throws -> [Account] {
            fatalError()
        }
        
        func fetchAllMemberWithLoan() async throws -> [Account] {
            fatalError()
        }
        
        func changeStatusForUser(account: Account) async throws -> Void {
            fatalError()
        }
        
        func addMonthlyFeeFor(account: Account, balance: Balance) async throws -> Void {
            fatalError()
        }
        
        func loanMember(account: Account, loan: Loan) async throws -> Void {
            fatalError()
        }
        
        func loanReturned(account: Account, loan: Loan) async throws -> Void {
            fatalError()
        }
        
        func updateExtraAndExpenses(groupDetail: GroupDetail, extra: Balance, expenses: Balance) async throws -> Void {
            fatalError()
        }
        
        func updateAmountFor(account: Account, balance: Balance) async throws-> Void {
            fatalError()
        }
        
        func fetchGroupDetail() async throws -> GroupDetail {
            fatalError()
        }
        
        func fetchNotice() async throws -> Notice {
            fatalError()
        }
        
        func updateNotice(account: Account, notice: Notice) async throws -> Void {
            fatalError()
        }
    }
}
