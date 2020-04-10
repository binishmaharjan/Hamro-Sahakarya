//
//  LogCellViewModel.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/01/26.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation

protocol LogCellViewModel {
  var groupLog: GroupLog { get }
  var title: String { get }
  var description: String { get }
  var dateCreated: String { get }
}

struct DefaultLogCellViewModel: LogCellViewModel {
  internal let groupLog: GroupLog
  
  var logId: String {
    return groupLog.logId
  }
  
  var dateCreated: String {
    return groupLog.dateCreated
  }
  
  var logType: GroupLogType {
    return groupLog.logType
  }
  
  var logCreator: String {
    return groupLog.logCreator
  }
  
  var logTarget: String {
    return groupLog.logTarget
  }
  
  var amount: Int {
    return groupLog.amount ?? 0
  }
  
  var reason: String {
    return groupLog.reason ?? ""
  }
  
  init(groupLog: GroupLog) {
    self.groupLog = groupLog
  }
  
  var title: String {
    switch logType {
    case .joined, .left, .madeAdmin, .removedAdmin:
      return "Organization Information Has Been Changed."
    case .loanGiven, .loanReturned, .monthlyFee, .extra, .expenses:
      return "A New Transaction Has Been Made."
    }
  }
  
  var description: String {
    switch logType {
    case .joined:
      return "\(logTarget) has joined the group.Initial amount of ¥\(amount) was given."
    case .left:
       return "\(logTarget) has left the group.Amount of ¥\(amount) was returned. New member was removed by admin \(logCreator)"
    case .loanGiven:
       return "\(logTarget) was given the loan of amount ¥\(amount). Transaction was made by admin \(logCreator)"
    case .loanReturned:
      return "\(logTarget) has returned the loan of amount ¥\(amount). Transaction was made by admin \(logCreator)"
    case .monthlyFee:
      return "\(logTarget) was given the monthly fee of amount ¥\(amount). Transaction was made by admin \(logCreator)"
    case .extra:
        return "¥\(amount) of was received as Extra. Transaction was made by admin \(logCreator).\n\n- Reason:\n\(reason)"
    case .expenses:
       return "¥\(amount) of was spend as Expenses. Transaction was made by admin \(logCreator).\n\n- Reason:\n\(reason)"
    case .madeAdmin:
       return "\(logTarget) has been made admin. \(logTarget) was made admin by \(logCreator)"
    case .removedAdmin:
      return "\(logTarget) has been removed from admin. \(logTarget) was removed from admin by \(logCreator)"
    }
  }
}
