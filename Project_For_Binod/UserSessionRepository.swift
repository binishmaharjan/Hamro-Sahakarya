//
//  UserSessionRepository.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/10/19.
//  Copyright © 2019 JEC. All rights reserved.
//

import Foundation
import PromiseKit

protocol UserSessionRepository {
    
    func readUserSession() -> Promise<UserSession?>
    func signUp(newAccount: NewAccount) -> Promise<UserSession>
    func signIn(email: String, password: String) -> Promise<UserSession>
    func signOut(userSession: UserSession) -> Promise<UserSession>
    func removeMember(admin: UserProfile, member: UserProfile) -> Promise<Void>
    
    func getLogs() -> Promise<[GroupLog]>
    func fetchMoreLogsFromLastSnapShot() -> Promise<[GroupLog]>
    func addMonthlyFeeLog(admin: UserProfile, user: UserProfile, amount: Int) -> Promise<Void>
    func updateExtraAndExpenses(admin: UserProfile, type: ExtraOrExpenses, amount: Int, reason: String) -> Promise<Void>
    func fetchExtraAndExpenses() -> Promise<GroupDetail> 
    func loanMember(admin: UserProfile, member: UserProfile, amount: Int) -> Promise<Void>
    func loanReturned(admin: UserProfile, member: UserProfile, amount: Int) ->Promise<Void>
    
    func changeProfilePicture(userSession: UserSession, image: UIImage) -> Promise<UserSession>
    func changePassword(userSession: UserSession, newPassword: String) -> Promise<String>
    func changeStatus(for user: UserProfile) -> Promise<Void>
    func getAllMembers() -> Promise<[UserProfile]>
    func getAllMembersWithLoan() -> Promise<[UserProfile]>
}
