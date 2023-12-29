import Foundation
import ComposableArchitecture
import SharedModels
import FirebaseFirestore

// MARK: Dependency (liveValue)
extension UserLogClient: DependencyKey {
    public static let liveValue = UserLogClient.live()
}

// MARK: - Live Implementation
extension UserLogClient {
    public static func live() -> UserLogClient {
        let session = Session()
        
        return UserLogClient(
            fetchLogs: { try await session.fetchLogs() },
            addJoinedLog: { try await session.addJoinedLog(admin: $0) },
            addMonthlyFeeLog: { try await session.addMonthlyFeeLog(admin: $0, user: $1, balance: $2) },
            addExtraOrExpensesLog: { try await session.addExtraOrExpensesLog(extraOrExpenses: $0, admin: $1, balance: $2, reason: $3) },
            addAmountOrDeductAmountLog: { try await session.addAmountOrDeductAmountLog(addOrDeduct: $0, admin: $1, user: $2, balance: $3) },
            addLoanMemberLog: { try await session.addLoanMemberLog(admin: $0, user: $1, loan: $2) },
            addLoanReturnedLog: { try await session.addLoanReturnedLog(admin: $0, user: $1, loan: $2)},
            addRemoveMemberLog: { try await session.addRemoveMemberLog(admin: $0, user: $1) }
        )
    }
}

extension UserLogClient {
    actor Session {
        func fetchLogs() async throws -> [GroupLog] {
            fatalError()
        }
        
        func addJoinedLog(admin: Account) async throws -> Void {
            fatalError()
        }
        
        func addMonthlyFeeLog(admin: Account, user: Account, balance: Balance) async throws -> Void {
            fatalError()
        }
        
        func addExtraOrExpensesLog(extraOrExpenses: ExtraOrExpenses, admin: Account, balance: Balance, reason: String) async throws -> Void {
            fatalError()
        }
        
        func addAmountOrDeductAmountLog(addOrDeduct: AddOrDeduct, admin: Account, user: Account, balance: Balance) async throws -> Void {
            fatalError()
        }
        
        func addLoanMemberLog(admin: Account, user: Account, loan: Loan) async throws -> Void {
            fatalError()
        }
        
        func addLoanReturnedLog(admin: Account, user: Account, loan: Loan) async throws -> Void {
            fatalError()
        }
        
        func addRemoveMemberLog(admin: Account, user: Account) async throws -> Void {
            fatalError()
        }
    }
}
