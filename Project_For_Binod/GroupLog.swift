//
//  GroupLog.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/01/19.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation

enum GroupLogType: String, Codable {
    
    //Amount
    case joined = "joined"
    case left = "left"
    case loanGiven = "loan_given"
    case loanReturned = "loan_returned"
    case monthlyFee = "monthly_fee"
    case extra = "extra"
    case expenses = "expenses"
    case removed = "removed"
    
    //Non Amount
    case madeAdmin = "made_admin"
    case removedAdmin = "removed_admin"
}

struct GroupLog: Codable, Equatable {
    
    let logId: String
    let dateCreated: String
    let logType: GroupLogType
    let logCreator: String
    let logTarget: String
    let amount: Int?
    let reason: String?
    
    private enum CodingKeys: String, CodingKey {
        case logId = "log_id"
        case dateCreated = "date_created"
        case logType = "log_type"
        case logCreator = "log_creator"
        case logTarget = "log_owner"
        case amount
        case reason
    }
    
}
