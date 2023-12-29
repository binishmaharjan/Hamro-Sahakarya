import Foundation
import ComposableArchitecture
import SharedModels

public struct UserLogClient {
    /// SignIn the user.
    ///
    /// - Parameters: none
    /// - Returns: all logs information
    public var fetchLogs: @Sendable () async throws -> [GroupLog]
    /// Add use joined log
    ///
    /// - Parameters admin: Admin who registered log.
    /// - Returns: Void
    public var addJoinedLog: @Sendable (Account) async throws -> Void
    /// Add monthly fee log
    ///
    /// - Parameters:
    ///   - admin: Admin who registered log.
    ///   - account: user account information
    ///   - balance: balance to be added
    /// - Returns: Void
    public var addMonthlyFeeLog: @Sendable (Account, Account, Balance) async throws -> Void
    /// Add extra or expense  log
    ///
    /// - Parameters:
    ///   - extraOrExpense: Extra or expenses
    ///   - admin: Admin who registered log.
    ///   - balance: balance amount to be added
    ///   - reason: Reason for the log
    /// - Returns: Void
    public var addExtraOrExpensesLog: @Sendable (ExtraOrExpenses, Account, Balance, String) async throws -> Void
    /// Add amount added or amount deducted  log
    ///
    /// - Parameters:
    ///   - addOrDeduct: Add or Deduct
    ///   - admin: Admin who registered log.
    ///   - account: member whose log is being added
    ///   - balance: balance amount to be added
    /// - Returns: Void
    public var addAmountOrDeductAmountLog: @Sendable (AddOrDeduct, Account, Account, Balance) async throws -> Void
    /// Add loan given log
    ///
    /// - Parameters:
    ///   - admin: Admin who registered log.
    ///   - account: member whose log is being added
    ///   - loan: loan given to the member
    /// - Returns: Void
    public var addLoanMemberLog: @Sendable (Account, Account, Loan) async throws -> Void
    /// Add loan returned log
    ///
    /// - Parameters:
    ///   - admin: Admin who registered log.
    ///   - account: member whose log is being added
    ///   - loan: loan returned to the member
    /// - Returns: Void
    public var addLoanReturnedLog: @Sendable (Account, Account, Loan) async throws -> Void
    /// Add remove member log
    ///
    /// - Parameters:
    ///   - admin: Admin who registered log.
    ///   - account: member whose log is being added
    /// - Returns: Void
    public var addRemoveMemberLog: @Sendable (Account, Account) async throws -> Void
}

// MARK: DependencyValues
extension DependencyValues {
    public var userLogClient: UserLogClient {
        get { self[UserLogClient.self] }
        set { self[UserLogClient.self] = newValue }
    }
}

// MARK: Dependency (testValue, previewValue)
extension UserLogClient: TestDependencyKey {
    public static let testValue = UserLogClient(
        fetchLogs: unimplemented(),
        addJoinedLog: unimplemented(),
        addMonthlyFeeLog: unimplemented(),
        addExtraOrExpensesLog: unimplemented(),
        addAmountOrDeductAmountLog: unimplemented(),
        addLoanMemberLog: unimplemented(),
        addLoanReturnedLog: unimplemented(),
        addRemoveMemberLog: unimplemented()
    )
    
    public static let previewValue = UserLogClient(
        fetchLogs: unimplemented(),
        addJoinedLog: unimplemented(),
        addMonthlyFeeLog: unimplemented(),
        addExtraOrExpensesLog: unimplemented(),
        addAmountOrDeductAmountLog: unimplemented(),
        addLoanMemberLog: unimplemented(),
        addLoanReturnedLog: unimplemented(),
        addRemoveMemberLog: unimplemented()
    )
}
