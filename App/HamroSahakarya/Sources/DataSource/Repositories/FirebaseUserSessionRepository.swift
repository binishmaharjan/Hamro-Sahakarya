import Core
import FirebaseAuth
import Foundation
import PromiseKit
import UIKit

public final class FirebaseUserSessionRepository: UserSessionRepository {
    // MARK: Properties
    private let dataStore: UserDataStore
    private let remoteApi: AuthRemoteApi
    private let serverDataManager: ServerDataManager
    private let logApi: LogRemoteApi
    private let storageApi: StorageRemoteApi

    // MARK: Init
    public init(dataStore: UserDataStore, remoteApi: AuthRemoteApi, serverDataManager: ServerDataManager, logApi: LogRemoteApi, storageApi: StorageRemoteApi) {
        self.dataStore = dataStore
        self.remoteApi = remoteApi
        self.serverDataManager = serverDataManager
        self.logApi = logApi
        self.storageApi = storageApi
    }

    // MARK: User
    /// Read user session from the local data store
    ///
    /// - Return Promise<UserSession> : UserInfo wrapped in promise
    public func readUserSession() -> Promise<UserSession?> {
        return dataStore.readUserProfile()
    }

    /// Save user session from the local data store
    ///
    /// - Return Promise<UserSession> : UserInfo wrapped in promise
    public func saveUserSession(userProfile: UserProfile) -> Promise<UserSession> {
        return dataStore.save(userProfile: userProfile)
    }

    /// Signup the user and save the user data to the local data store
    ///
    /// - Parameter newAccount: User info for the new account
    /// - Return Promise<UserSession> : UserInfo wrapped in promise
    public func signUp(newAccount: NewAccount) -> Promise<UserSession> {

        let signUpTheUser = remoteApi.signUp(newAccount: newAccount)
        let saveDataToServer = signUpTheUser.then { (uid) -> Promise<UserSession> in

            let userProfile = newAccount.createUserProfile(with: uid)

            return self.serverDataManager.saveUser(userProfile: userProfile)
        }

        let saveUserToDataStore = saveDataToServer.map { $0.profile.value }.then(dataStore.save(userProfile:))

        let addLog = saveUserToDataStore.then(logApi.addJoinedLog(userSession:))

        return addLog

    }

    /// Signin the uset and save the user data to the local data store
    ///
    /// - Parameter email: Email Id of user
    /// - Parameter password: Password
    /// - Return Promise<UserSession> : UserInfo wrapped in promise
    public func signIn(email: String, password: String) -> Promise<UserSession> {
        return remoteApi.signIn(email: email, password: password)
            .then(serverDataManager.readUser(uid:))
            .map { $0?.profile.value }
            .then(dataStore.save(userProfile:))
    }

    /// Signout User
    ///
    /// - Parameter userSession: Current User Session
    /// - Return Promise<UserSession> : UserInfo wrapped in promise
    public func signOut(userSession: UserSession) -> Promise<UserSession> {
        return remoteApi.signOut(userSession: userSession)
            .map { $0.profile.value }
            .then(dataStore.delete(userProfile:))
    }

    /// Change User Password
    ///
    /// - Parameter userSession: Current User Session
    /// - Parameter newPassword: NewPassword
    /// - Return Promise<Void> : Void wrapped in promise
    public func changePassword(userSession: UserSession, newPassword: String) -> Promise<String> {
        return remoteApi.changePassword(newPassword: newPassword)
            .map { (userSession, $0) }
            .then(serverDataManager.updatePassword(userSession: newPassword:))
    }

    // MARK: Logs

    /// Get all the group logs
    ///
    /// - Return Promise<[Group Log]> : logs wrapped in promise
    public func getLogs() -> Promise<[GroupLog]> {
        return logApi.getLogs()
    }

    /// Fetch all the group logs from the last snapshot
    ///
    /// - Return Promise<[Group Log]> : logs wrapped in promise
    public func fetchMoreLogsFromLastSnapShot() -> Promise<[GroupLog]> {
        return logApi.fetchLogsFromLastSnapshot()
    }

    /// Change Member Status
    ///
    /// - Parameter user: The specific user whose status is to be changed
    /// - Return Promise<Void> : returns  a empty promise
    public func changeStatus(for user: UserProfile) -> Promise<Void> {
        return serverDataManager.changeStatus(for: user)
    }

    /// Get All Members
    ///
    /// - Return Promise<[UserProfile]>: All member list wrapped in promise
    public func getAllMembers() -> Promise<[UserProfile]> {
        return serverDataManager.getAllMembers()
    }

    /// Get all members who have taken loan
    ///
    /// - Return Promise<[UserProfile]>: All member who have taken loan wrapped in promise
    public func getAllMembersWithLoan() -> Promise<[UserProfile]> {
        return serverDataManager.getAllMemberWithLoan()
    }

    /// Get all members who have taken loan
    ///
    ///- Return Promise<Void> : Void wrapped in promise
    public func removeMember(admin: UserProfile, member: UserProfile) -> Promise<Void> {
        return serverDataManager.removeMember(user: member)
            .map { (admin, member) }
            .then(logApi.addRemoveMemberLog(admin: member:))
    }

    // MARK: Storage

    /// Change the profile picture
    ///
    /// - Parameter userSession: User Profile Information
    /// - Parameter image: New Image
    /// - Return Promise<URL> : Url of saved image wrapped in promise
    public func changeProfilePicture(userSession: UserSession, image: UIImage) -> Promise<UserSession> {
        return storageApi.saveImage(userSession: userSession, image: image)
            .map { (userSession, $0) }
            .then(serverDataManager.updateProfileUrl(userSession: url:))
            .then(serverDataManager.readUser(uid:))
            .map { $0?.profile.value }
            .then(dataStore.save(userProfile:))
    }

    // MARK: Update

    /// Update Extra Or Expenses
    ///
    /// - Parameter admin: Admin who made the transaction
    /// - Parameter type: Extra or Expenses
    /// - Parameter amount: Amount to be added
    /// - Parameter reason: Reason that was added
    /// - Return Promise<Void> : Indication of Completion
    public func updateExtraAndExpenses(admin: UserProfile, type: ExtraOrExpenses, amount: Int, reason: String) -> Promise<Void> {
        let extra: Int, expenses: Int
        if case ExtraOrExpenses.extra = type {
            extra = amount
            expenses = 0
        } else {
            extra = 0
            expenses = amount
        }

        return serverDataManager.fetchExtraAndExpenses()
            . map { ($0, extra, expenses) }
            .then(serverDataManager.updateExtraAndExpenses(groupDetail: extra: expenses: ))
            .map { (type, admin, amount, reason) }
            .then(logApi.addExtraOrExpensesLog(type: admin: amount: reason:))
    }

    /// Add or Deduct Amount From User
    ///
    /// - Parameter admin: Admin who made the transaction
    /// - Parameter type: Add Or Deduct
    /// - Parameter amount: Amount to be Added or Deducted
    /// - Return Promise<Void> : Indication of Completion
    public func addOrDeductAmount(admin: UserProfile, member: UserProfile, type: AddOrDeduct, amount: Int) -> Promise<Void> {
        var newAmount = member.balance
        if case .add = type {
            newAmount = member.balance + amount
        } else {
            newAmount = member.balance - amount
        }

        return serverDataManager
            .updateAmount(for: member, amount: newAmount)
            .map { (type, admin, member, amount) }
            .then(logApi.addAmountOrDeductAmountLog(type:admin: member: amount:))
    }

    /// Fetch Extra And Expenses
    ///
    /// - Return Promise<GroupDetail> : Extra And Expenses Wrapped In Promise
    public func fetchExtraAndExpenses() -> Promise<GroupDetail> {
        return serverDataManager
            .fetchExtraAndExpenses()
    }

    /// Add Monthyl Fee For A Single User
    ///
    /// - Parameter admin: Admin who made the transaction
    /// - Parameter user: Target User
    /// - Parameter amount: Amount to be added
    /// - Return Promise<Void> : Indication of Completion
    public func addMonthlyFeeLog(admin: UserProfile, user: UserProfile, amount: Int) -> Promise<Void> {
        return serverDataManager.addMonthlyFee(for: user, amount: amount)
            .map { (admin, user, amount) }
            .then(logApi.addMonthlyFeeLog(admin: userProfile: amount:))
    }

    /// Give Loan to a member
    ///
    /// - Parameter admin: Admin who made the transaction
    /// - Parameter member: Target User
    /// - Parameter amount: Amount to be added
    /// - Return Promise<Void> : Indication of Completion
    public func loanMember(admin: UserProfile, member: UserProfile, amount: Int) -> Promise<Void>  {
        return serverDataManager
            .loanMember(user: member, amount: amount)
            .map { (admin, member, amount) }
            .then( logApi.addLoanMemberLog(admin: member: amount:))
    }

    /// Member returned a loan
    ///
    /// - Parameter admin: Admin who made the transaction
    /// - Parameter member: Target User
    /// - Parameter amount: Amount to be added
    /// - Return Promise<Void> : Indication of Completion
    public func loanReturned(admin: UserProfile, member: UserProfile, amount: Int) ->Promise<Void> {
        return serverDataManager
            .loanReturned(user: member, amount: amount)
            .map { (admin, member, amount) }
            .then(logApi.addLoanReturnedLog(admin: member: amount:))
    }

    /// Fetch Notice From The Server
    ///
    /// - Return Promise<Notice> : Notice wrapped in promise
    public func fetchNotice() -> Promise<Notice>  {
        return serverDataManager.fetchNotice()
    }

    /// Update Notice
    ///
    /// - Return Promise<Void> : Indication of Completion
    public func updateNotice(userProfile: UserProfile, notice: String) -> Promise<Void> {
        return serverDataManager.updateNotice(userProfile: userProfile, notice: notice)
    }

    /// Downloads Terms And Condition PDF from Firebase storage
    ///
    /// - Return Promise<Data> : PDF Data wrapped in promise
    public func downloadTermsAndCondition() -> Promise<Data> {
        return storageApi.downloadTermsAndCondition()
    }
}


