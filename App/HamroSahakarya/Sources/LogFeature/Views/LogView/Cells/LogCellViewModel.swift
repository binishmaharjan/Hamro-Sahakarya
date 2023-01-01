import Core
import Foundation

public protocol LogCellViewModel {
    var title: String { get }
    var description: String { get }
    var dateCreated: String { get }
}

public struct DefaultLogCellViewModel: LogCellViewModel {
    private let groupLog: GroupLog
    
    var logId: String {
        return groupLog.logId
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
    
    var amount: String {
        return groupLog.amount?.currency ?? "¥0"
    }
    
    var reason: String {
        return groupLog.reason ?? ""
    }
    
    public init(groupLog: GroupLog) {
        self.groupLog = groupLog
    }

    public var dateCreated: String {
        return groupLog.dateCreated.toDateAndTime.toGregorianMonthDateYearString
    }
    
    public var title: String {
        switch logType {
        case .joined, .left, .madeAdmin, .removedAdmin, .removed:
            return "Organization Information Has Been Changed."
        case .loanGiven, .loanReturned, .monthlyFee, .extra, .expenses, .addAmount, .deductAmount:
            return "A New Transaction Has Been Made."
        }
    }
    
    public var description: String {
        switch logType {
        case .joined:
            return "\(logTarget) has joined the group.Initial amount of \(amount) was given."
        case .removed:
            return "\(logTarget) has left the group.Amount of \(amount) was returned to \(logTarget)."
        case .left:
            return "\(logTarget) has left the group.Amount of \(amount) was returned. New member was removed by admin \(logCreator)"
        case .loanGiven:
            return "\(logTarget) was given the loan of amount \(amount). Transaction was made by admin \(logCreator)"
        case .loanReturned:
            return "\(logTarget) has returned the loan of amount \(amount). Transaction was made by admin \(logCreator)"
        case .monthlyFee:
            return "\(logTarget) was given the monthly fee of amount \(amount). Transaction was made by admin \(logCreator)"
        case .extra:
            return "\(amount) of was received as Extra. Transaction was made by admin \(logCreator).\n\n- Reason:\n\(reason)"
        case .expenses:
            return "\(amount) of was spend as Expenses. Transaction was made by admin \(logCreator).\n\n- Reason:\n\(reason)"
        case .madeAdmin:
            return "\(logTarget) has been made admin. \(logTarget) was made admin by \(logCreator)"
        case .removedAdmin:
            return "\(logTarget) has been removed from admin. \(logTarget) was removed from admin by \(logCreator)"
        case .addAmount:
            return "An amount of \(amount) has been added to \(logTarget).Transaction was made by admin \(logCreator)."
        case .deductAmount:
            return "An amount of \(amount) has been deducted to \(logTarget).Transaction was made by admin \(logCreator)."
        }
    }
}
