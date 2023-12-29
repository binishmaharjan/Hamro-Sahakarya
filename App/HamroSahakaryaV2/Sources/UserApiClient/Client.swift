import Foundation
import Dependencies
import SharedModels
import SwiftUI

public struct UserApiClient {
    /// SignIn the user.
    ///
    /// - Parameters:
    ///   - email: Email Id of user
    ///   - password: Password for the account
    /// - Returns: AccountId
    public var signIn: @Sendable (Email, Password) async throws -> Account
    /// Create new account for the user and add log to the server. Only Admin can create new accounts
    ///
    /// - Parameter newAccount: User info for the new account
    /// - Returns: AccountId
    public var createUser: @Sendable (NewAccount) async throws -> Account
    /// SignOut User
    ///
    /// - Parameter none
    /// - Returns: Void
    public var signOut: @Sendable (Account) async throws -> Void
    /// Delete User Account Information from the server and add log to the server
    ///
    /// - Parameters account: Account Information to delete
    /// - Returns: Void
    public var removeMember: @Sendable (Account, Account) async throws -> Void
    /// Fetch all logs
    ///
    /// - Parameters: none
    /// - Returns: all logs information
    public var getLogs: @Sendable () async throws -> [GroupLog]
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
    public var addExtraAndExpenses: @Sendable (Account, ExtraOrExpenses, Balance, String) async throws -> Void
    /// Add amount added or amount deducted  log
    ///
    /// - Parameters:
    ///   - addOrDeduct: Add or Deduct
    ///   - admin: Admin who registered log.
    ///   - account: member whose log is being added
    ///   - balance: balance amount to be added
    /// - Returns: Void
    public var addOrDeductAmount: @Sendable (Account, Account, AddOrDeduct, Balance) async throws -> Void
    /// Fetch group detail
    ///
    /// - Parameters: none
    /// - Returns: Current Group Detail
    public var fetchGroupDetail: @Sendable () async throws -> GroupDetail
    /// Loan a member and log to the server
    ///
    /// - Parameters:
    ///  - admin: Admin who registered log
    ///  - account: Account Information to update
    ///  - newPassword: Loan amount
    /// - Returns: Void
    public var loanMember: @Sendable (Account, Account, Loan) async throws -> Void
    /// Loan returned by a member and save log to the server
    ///
    /// - Parameters:
    ///  - admin: Admin who registered log.
    ///  - account: Account Information to update
    ///  - newPassword: Loan amount
    /// - Returns: Void
    public var loanReturned: @Sendable (Account, Account, Loan) async throws -> Void
    /// Change profile image and save it to the server
    ///
    /// - Parameters:
    ///   - user: User account to save user profile image
    ///   - image: UIImageData
    /// - Returns: URL in the storage
    public var changeProfileImage: @Sendable (Account, Image) async throws -> Void
    /// Update the keyword saved in the Account Information
    ///
    /// - Parameters:
    ///  - account: Account Information to update
    ///  - newPassword: New Password set to the url
    /// - Returns: Void
    public var changePassword: @Sendable (Account, Password) async throws -> Void
    /// Change User Status for the member
    ///
    /// - Parameters account: Member status whose status needs to be changed
    /// - Returns: Void
    public var changeStatusForUser: @Sendable (Account) async throws -> Void
    /// Fetch the information of the all members
    ///
    /// - Parameters: none
    /// - Returns: Account information of all members
    public var fetchAllMembers: @Sendable () async throws -> [Account]
    /// Fetch the information of the all members who have taken loan
    ///
    /// - Parameters: none
    /// - Returns: Account information of all members
    public var fetchAllMembersWithLoan: @Sendable () async throws -> [Account]
    /// Fetch current notice information
    ///
    /// - Parameters: none
    /// - Returns: Current Notice Information
    public var fetchNotice: @Sendable () async throws -> Notice
    /// Update amount for a user
    ///
    /// - Parameters:
    ///  - account: Admin who updated the notice
    ///  - notice: new notice
    /// - Returns: Void
    public var updateNotice: @Sendable (Account, Notice) async throws -> Void
    /// Download terms and condition pdf
    ///
    /// - Parameters: none
    /// - Returns: PDF data
    public var downloadTermsAndCondition: @Sendable () async throws -> Data
}

// MARK: DependencyValues
extension DependencyValues {
    public var userApiClient: UserApiClient {
        get { self[UserApiClient.self] }
        set { self[UserApiClient.self] = newValue }
    }
}

extension UserApiClient: TestDependencyKey {
    public static var testValue = UserApiClient(
        signIn: unimplemented(),
        createUser: unimplemented(),
        signOut: unimplemented(),
        removeMember: unimplemented(),
        getLogs: unimplemented(),
        addMonthlyFeeLog: unimplemented(),
        addExtraAndExpenses: unimplemented(),
        addOrDeductAmount: unimplemented(),
        fetchGroupDetail: unimplemented(),
        loanMember: unimplemented(),
        loanReturned: unimplemented(),
        changeProfileImage: unimplemented(),
        changePassword: unimplemented(),
        changeStatusForUser: unimplemented(),
        fetchAllMembers: unimplemented(),
        fetchAllMembersWithLoan: unimplemented(),
        fetchNotice: unimplemented(),
        updateNotice: unimplemented(),
        downloadTermsAndCondition: unimplemented()
    )
    
    public static var previewValue = UserApiClient(
        signIn: unimplemented(),
        createUser: unimplemented(),
        signOut: unimplemented(),
        removeMember: unimplemented(),
        getLogs: unimplemented(),
        addMonthlyFeeLog: unimplemented(),
        addExtraAndExpenses: unimplemented(),
        addOrDeductAmount: unimplemented(),
        fetchGroupDetail: unimplemented(),
        loanMember: unimplemented(),
        loanReturned: unimplemented(),
        changeProfileImage: unimplemented(),
        changePassword: unimplemented(),
        changeStatusForUser: unimplemented(),
        fetchAllMembers: unimplemented(),
        fetchAllMembersWithLoan: unimplemented(),
        fetchNotice: unimplemented(),
        updateNotice: unimplemented(),
        downloadTermsAndCondition: unimplemented()
    )
}
