import Foundation
import Dependencies
import DependenciesMacros
import SharedModels
import UIKit

@DependencyClient
public struct UserApiClient {
    /// SignIn the user.
    ///
    /// - Parameters:
    ///   - email: Email Id of user
    ///   - password: Password for the user account
    /// - Returns: User
    public var signIn: @Sendable (_ withEmail: Email, _ password: Password) async throws -> User
    /// Create new account for the user and add log to the server. Only Admin can create new accounts
    ///
    /// - Parameter newUser: User info for the new account
    /// - Returns: User
    public var createUser: @Sendable (_ with: NewUser) async throws -> User
    /// Forgot Password
    ///
    /// - Parameter email: Email to send password reset mail.
    /// - Returns: Void
    public var sendPasswordReset: @Sendable (_ withEmail: Email) async throws -> Void
    /// SignOut User
    ///
    /// - Parameter none
    /// - Returns: Void
    public var signOut: @Sendable () async throws -> Void
    /// Delete User Account Information from the server and add log to the server
    ///
    /// - Parameters:
    ///   - admin: admin who is taking the action
    ///   - user: user Information to delete
    /// - Returns: Void
    public var removeMember: @Sendable (_ by: User, _ user: User) async throws -> Void
    /// Fetch all logs
    ///
    /// - Parameters: none
    /// - Returns: all logs information
    public var fetchLogs: @Sendable () async throws -> [GroupLog]
    /// Add monthly fee log
    ///
    /// - Parameters:
    ///   - admin: Admin who registered log.
    ///   - user: user account information
    ///   - balance: balance to be added
    /// - Returns: Void
    public var addMonthlyFee: @Sendable (_ by: User, _ user: User, _ balance: Balance) async throws -> Void
    /// Add extra or expense  log
    ///
    /// - Parameters:
    ///   - extraOrExpense: Extra or expenses
    ///   - admin: Admin who registered log.
    ///   - balance: balance amount to be added
    ///   - reason: Reason for the log
    /// - Returns: Void
    public var addExtraAndExpenses: @Sendable (_ for: ExtraOrExpenses, _ admin: User, _ balance: Balance, _ reason: String) async throws -> Void
    /// Add amount added or amount deducted  log
    ///
    /// - Parameters:
    ///   - addOrDeduct: Add or Deduct
    ///   - admin: Admin who registered log.
    ///   - user: member whose log is being added
    ///   - balance: balance amount to be added
    /// - Returns: Void
    public var addOrDeductAmount: @Sendable (_ for: AddOrDeduct, _ admin: User, _ user: User, _ balance: Balance) async throws -> Void
    /// Fetch group detail
    ///
    /// - Parameters: none
    /// - Returns: Current Group Detail
    public var fetchGroupDetail: @Sendable () async throws -> GroupDetail
    /// Loan a member and log to the server
    ///
    /// - Parameters:
    ///  - admin: Admin who registered log
    ///  - user: Account Information to update
    ///  - amount: Loan amount
    /// - Returns: Void
    public var loanGiven: @Sendable (_ by: User, _ user: User, _ loan: Loan) async throws -> Void
    /// Loan returned by a member and save log to the server
    ///
    /// - Parameters:
    ///  - admin: Admin who registered log.
    ///  - user: Account Information to update
    ///  - newPassword: Loan amount
    /// - Returns: Void
    public var loanReturned: @Sendable (_ by: User, _ user: User, _ loan: Loan) async throws -> Void
    /// Change profile image and save it to the server
    ///
    /// - Parameters:
    ///   - user: User account to save user profile image
    ///   - image: UIImageData
    /// - Returns: URL in the storage
    public var changeProfileImage: @Sendable (_ for: User, _ image: UIImage) async throws -> Void
    /// Update the keyword saved in the Account Information
    ///
    /// - Parameters:
    ///  - user: Account Information to update
    ///  - newPassword: New Password set to the url
    /// - Returns: Void
    public var changePassword: @Sendable (_ for: User, _ newPassword: Password) async throws -> Void
    /// Change User Status for the member
    ///
    /// - Parameters user: Member status whose status needs to be changed
    /// - Returns: Void
    public var changeStatus: @Sendable (_ for: User) async throws -> Void
    /// Fetch the information of the all members
    ///
    /// - Parameters: none
    /// - Returns: Account information of all members
    public var fetchAllMembers: @Sendable () async throws -> [User]
    /// Fetch the information of the all members who have taken loan
    ///
    /// - Parameters: none
    /// - Returns: Account information of all members
    public var fetchAllMembersWithLoan: @Sendable () async throws -> [User]
    /// Fetch current notice information
    ///
    /// - Parameters: none
    /// - Returns: Current Notice Information
    public var fetchNotice: @Sendable () async throws -> Notice
    /// Update amount for a user
    ///
    /// - Parameters:
    ///  - admin: Admin who updated the notice
    ///  - message: new notice
    /// - Returns: Void
    public var updateNotice: @Sendable (_ by: User, _ message: String) async throws -> Void
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
        sendPasswordReset: unimplemented(),
        signOut: unimplemented(),
        removeMember: unimplemented(),
        fetchLogs: unimplemented(),
        addMonthlyFee: unimplemented(),
        addExtraAndExpenses: unimplemented(),
        addOrDeductAmount: unimplemented(),
        fetchGroupDetail: unimplemented(),
        loanGiven: unimplemented(),
        loanReturned: unimplemented(),
        changeProfileImage: unimplemented(),
        changePassword: unimplemented(),
        changeStatus: unimplemented(),
        fetchAllMembers: unimplemented(),
        fetchAllMembersWithLoan: unimplemented(),
        fetchNotice: unimplemented(),
        updateNotice: unimplemented(),
        downloadTermsAndCondition: unimplemented()
    )
    
    public static var previewValue = UserApiClient(
        signIn: unimplemented(),
        createUser: unimplemented(),
        sendPasswordReset: unimplemented(),
        signOut: unimplemented(),
        removeMember: unimplemented(),
        fetchLogs: unimplemented(),
        addMonthlyFee: unimplemented(),
        addExtraAndExpenses: unimplemented(),
        addOrDeductAmount: unimplemented(),
        fetchGroupDetail: unimplemented(),
        loanGiven: unimplemented(),
        loanReturned: unimplemented(),
        changeProfileImage: unimplemented(),
        changePassword: unimplemented(),
        changeStatus: unimplemented(),
        fetchAllMembers: unimplemented(),
        fetchAllMembersWithLoan: unimplemented(),
        fetchNotice: unimplemented(),
        updateNotice: unimplemented(),
        downloadTermsAndCondition: unimplemented()
    )
}
