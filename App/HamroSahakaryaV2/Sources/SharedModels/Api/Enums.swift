import Foundation

public enum ExtraOrExpenses: String, CaseIterable {
    case extra = "Extra Income"
    case expenses = "Expenses"
}

public enum AddOrDeduct: String, CaseIterable {
    case add = "Add Amount"
    case deduct = "Deduct Amount"
}

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
