//
//  LogRemoteApi.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/01/19.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation
import PromiseKit

protocol LogRemoteApi {
    func getLogs() -> Promise<[GroupLog]>
    func fetchLogsFromLastSnapshot() -> Promise<[GroupLog]>
    func addJoinedLog(userSession: UserSession) -> Promise<UserSession>
    func addMonthlyFeeLog(admin: UserProfile, userProfile: UserProfile, amount: Int) -> Promise<Void>
    func addExtraOrExpensesLog(type: ExtraOrExpenses, admin: UserProfile, amount: Int, reason: String) -> Promise<Void>
    func addLoanMemberLog(admin: UserProfile, member: UserProfile, amount: Int) -> Promise<Void>
    func addLoanReturnedLog(admin: UserProfile, member: UserProfile, amount: Int) -> Promise<Void>
    func addRemoveMemberLog(admin: UserProfile, member: UserProfile) -> Promise<Void>
}
