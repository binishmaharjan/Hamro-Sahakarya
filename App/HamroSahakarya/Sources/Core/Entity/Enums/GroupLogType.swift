import Foundation

public enum GroupLogType: String, Codable {
    // Amount
    case joined = "joined"
    case left = "left"
    case loanGiven = "loan_given"
    case loanReturned = "loan_returned"
    case monthlyFee = "monthly_fee"
    case extra = "extra"
    case expenses = "expenses"
    case removed = "removed"
    case addAmount = "add_amount"
    case deductAmount = "deduct_amount"

    // Non Amount
    case madeAdmin = "made_admin"
    case removedAdmin = "removed_admin"
}

