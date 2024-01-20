import Foundation
import SharedModels
import SharedUIs
import SwiftUI

extension GroupLog {
    var logTitle: String {
        switch logType {
        case .joined:
            return #localized("A New Member has Joined")
        case .left, .removed:
            return #localized("A Member Left the Group")
        case .loanGiven:
            return #localized("Loan Given to Member")
        case .loanReturned:
            return #localized("Loan Repayment by Member")
        case .monthlyFee:
            return #localized("Monthly Fee Received")
        case .extra:
            return #localized("Extra Amount Added")
        case .expenses:
            return #localized("Expenses Incurred")
        case .addAmount:
            return #localized("Amount Added to Member")
        case .deductAmount:
            return #localized("Amount Deducted from Member")
        case .madeAdmin:
            return #localized("Promoted to Admin")
        case .removedAdmin:
            return #localized("Demoted to Member")
        }
    }
    
    var icon: Image {
        switch logType {
        case .joined, .left, .removed:
            return #img("icon_person")
        case .loanGiven, .loanReturned, .monthlyFee, .extra, .expenses, .addAmount, .deductAmount:
            return #img("icon_yen")
        case .madeAdmin, .removedAdmin:
            return #img("icon_admin")
        }
    }
    
    var logDescription: String {
        switch logType {
        case .joined:
            return #localized("\(logTarget) has joined the group and provided the fixed deposit of \(amount.safeUnwrap.jaCurrency). Welcome to the group.")
        case .left, .removed:
            return #localized("\(logTarget) has left the group. The deposit of \(amount.safeUnwrap.jaCurrency) has been returned. Thank you for being part of the group.")
        case .loanGiven:
            return #localized("A loan of \(amount.safeUnwrap.jaCurrency) has been provided to \(logTarget). This transaction was authorized by admin \(logCreator).")
        case .loanReturned:
            return #localized("\(logTarget) has made a loan repayment of \(amount.safeUnwrap.jaCurrency). This transaction was authorized by admin \(logCreator).")
        case .monthlyFee:
            return #localized("\(logTarget) has given a monthly fee of \(amount.safeUnwrap.jaCurrency). This transaction was authorized by admin \(logCreator).")
        case .extra:
            return #localized("An extra amount of \(amount.safeUnwrap.jaCurrency) has been added to the group. This transaction was authorized by admin \(logCreator).\n\nReason: \(reason.safeUnwrap)")
        case .expenses:
            return #localized("Expenses amounting to \(amount.safeUnwrap.jaCurrency) have been incurred in the group. This transaction was authorized by admin \(logCreator).\n\nReason: \(reason.safeUnwrap)")
        case .addAmount: return #localized("An amount of \(amount.safeUnwrap.jaCurrency) has been added to the account of \(logTarget) in the group. This transaction was authorized by admin \(logCreator).")
        case .deductAmount:
            return #localized("An amount of \(amount.safeUnwrap.jaCurrency) has been deducted from the account of \(logTarget) in the group. This transaction was authorized by admin \(logCreator).")
        case .madeAdmin: 
            return #localized("\(logTarget) has promoted [Member Name] to the position of [Admin] by admin \(logCreator).")
        case .removedAdmin:
            return #localized("\(logTarget) has demoted from the position of [Admin] to a regular member by admin \(logCreator).")
        }
    }
}

// MARK: Year And Month For Sorting
extension GroupLog {
    var yearMonth: Date.FormatStyle.FormatOutput {
        dateCreated.toDate(for: .dateTime).formatted(.dateTime.year().month())
    }
}


// MARK: Sort
extension Array where Element == GroupLog {
    typealias LogDictionary = [Date.FormatStyle.FormatOutput: [GroupLog]]
    func groupByYearAndMonth() -> [GroupedLogs] {
        // Grouping Logs with YearMonth(Date.FormatStyle.FormatOutput)
        var logsDictionary: LogDictionary = Dictionary(
            grouping: self,
            by: { $0.yearMonth }
        )
        // Within each group, sorting Logs with date created.
        logsDictionary.forEach {
            logsDictionary[$0] = $1.sorted(using: KeyPathComparator(\.dateCreated)).reversed()
        }
        // Sort the group by YearMonth
        let sortedGroupedLog = logsDictionary
            .sorted {
                return $0.key.toDate(for: .monthYear) > $1.key.toDate(for: .monthYear)
            }
            .map(GroupedLogs.init(element:))
        return sortedGroupedLog
    }
}
