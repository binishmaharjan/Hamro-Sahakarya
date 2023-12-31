import Foundation
import Dependencies
import SharedModels

public struct UserDataClient {
    /// Fetch User Account Information for the server
    ///
    /// - Parameters uuid: AccountId of which data to fetch
    /// - Returns: AccountId
    public var fetch: @Sendable (AccountId) async throws -> Account
    /// Save User Account Information to the server
    ///
    /// - Parameters account: Account Information to save
    /// - Returns: Void
    public var save: @Sendable (Account) async throws -> Void
    /// Delete User Account Information from the server
    ///
    /// - Parameters account: Account Information to delete
    /// - Returns: Void
    public var remove: @Sendable (Account) async throws -> Void
    /// Update the url for image data to the Account Information
    ///
    /// - Parameters:
    ///  - account: Account Information to update
    ///  - imageUrl: Url of the image in the storage
    /// - Returns: Void
    public var updateImageUrl: @Sendable (Account, ImageUrl) async throws -> Void
    /// Update the keyword saved in the Account Information
    ///
    /// - Parameters:
    ///  - account: Account Information to update
    ///  - newPassword: New Password set to the url
    /// - Returns: Void
    public var changePassword: @Sendable (Account, Password) async throws -> Void
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
    /// Change User Status for the member
    ///
    /// - Parameters account: Member status whose status needs to be changed
    /// - Returns: Void
    public var changeStatusForUser: @Sendable (Account) async throws -> Void
    /// Add Monthly Fee for single User.
    ///
    /// - Parameters:
    ///  - account: Account Information to update
    ///  - newPassword: Balance to be added
    /// - Returns: Void
    public var addMonthlyFeeFor: @Sendable (Account, Balance) async throws -> Void
    /// Loan a member
    ///
    /// - Parameters:
    ///  - account: Account Information to update
    ///  - newPassword: Loan amount
    /// - Returns: Void
    public var loanMember: @Sendable (Account, Loan) async throws -> Void
    /// Loan returned by a member
    ///
    /// - Parameters:
    ///  - account: Account Information to update
    ///  - newPassword: Loan amount
    /// - Returns: Void
    public var loanReturned: @Sendable (Account, Loan) async throws -> Void
    /// Update extra and expenses amount of group.
    ///
    /// - Parameters:
    ///  - groupDetail: Current group detail
    ///  - extra: new extra amount
    ///  - expenses: new expenses amount
    /// - Returns: Void
    public var updateExtraAndExpenses: @Sendable (GroupDetail, Balance, Balance) async throws -> Void
    /// Update amount for a user
    ///
    /// - Parameters:
    ///  - account: Account Information to update
    ///  - balance: new balance
    /// - Returns: Void
    public var updateAmountFor: @Sendable (Account, Balance) async throws -> Void
    /// Fetch group detail
    ///
    /// - Parameters: none
    /// - Returns: Current Group Detail
    public var fetchGroupDetail: @Sendable () async throws -> GroupDetail
    /// Fetch current notice information
    ///
    /// - Parameters: none
    /// - Returns: Current Notice Information
    public var fetchNotice: @Sendable () async throws -> Notice
    /// Update amount for a user
    ///
    /// - Parameters:
    ///  - account: Admin who updated the notice
    ///  - message: new notice
    /// - Returns: Void
    public var updateNotice: @Sendable (Account, String) async throws -> Void
}

// MARK: DependencyValues
extension DependencyValues {
    public var userDataClient: UserDataClient {
        get { self[UserDataClient.self] }
        set { self[UserDataClient.self] = newValue }
    }
}

// MARK: Dependency (testValue, previewValue)
extension UserDataClient: TestDependencyKey {
    public static var testValue = UserDataClient(
        fetch: unimplemented(),
        save: unimplemented(),
        remove: unimplemented(),
        updateImageUrl: unimplemented(),
        changePassword: unimplemented(),
        fetchAllMembers: unimplemented(),
        fetchAllMembersWithLoan: unimplemented(),
        changeStatusForUser: unimplemented(),
        addMonthlyFeeFor: unimplemented(),
        loanMember: unimplemented(),
        loanReturned: unimplemented(),
        updateExtraAndExpenses: unimplemented(),
        updateAmountFor: unimplemented(),
        fetchGroupDetail: unimplemented(),
        fetchNotice: unimplemented(),
        updateNotice: unimplemented()
    )
    
    public static var previewValue =  UserDataClient(
        fetch: unimplemented(),
        save: unimplemented(),
        remove: unimplemented(),
        updateImageUrl: unimplemented(),
        changePassword: unimplemented(),
        fetchAllMembers: unimplemented(),
        fetchAllMembersWithLoan: unimplemented(),
        changeStatusForUser: unimplemented(),
        addMonthlyFeeFor: unimplemented(),
        loanMember: unimplemented(),
        loanReturned: unimplemented(),
        updateExtraAndExpenses: unimplemented(),
        updateAmountFor: unimplemented(),
        fetchGroupDetail: unimplemented(),
        fetchNotice: unimplemented(),
        updateNotice: unimplemented()
    )
}
