//
//  ServerDataManager.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/11/09.
//  Copyright © 2019 JEC. All rights reserved.
//

import Foundation
import PromiseKit

protocol ServerDataManager {
    
    func saveUser(userProfile: UserProfile) -> Promise<UserSession>
    func readUser(uid: String) -> Promise<UserSession?>
    func updateProfileUrl(userSession: UserSession, url: URL) -> Promise<String>
    func updatePassword(userSession: UserSession, newPassowrd: String) -> Promise<String>
    func getAllMembers() -> Promise<[UserProfile]>
    func getAllMemberWithLoan() -> Promise<[UserProfile]>
    func changeStatus(for user: UserProfile) -> Promise<Void>
    func addMonthlyFee(for user: UserProfile, amount: Int) -> Promise<Void>
    func loanMember(user: UserProfile, amount: Int) -> Promise<Void>
    func loanReturned(user: UserProfile, amount: Int) -> Promise<Void>
    func updateExtraAndExpenses(groupDetail: GroupDetail, extra: Int, expenses: Int) -> Promise<Void>
    func updateAmount(for user: UserProfile, amount: Int) -> Promise<Void>
    func fetchExtraAndExpenses() -> Promise<GroupDetail>
    func removeMember(user: UserProfile) -> Promise<Void>
    func fetchNotice() -> Promise<Notice>
}
