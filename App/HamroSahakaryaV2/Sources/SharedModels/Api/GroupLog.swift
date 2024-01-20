import Foundation

public struct GroupLog: Codable, Equatable, Hashable {
    public let logId: String
    public let dateCreated: String
    public let logType: GroupLogType
    public let logCreator: String
    public let logTarget: String
    public let amount: Int?
    public let reason: String?

    private enum CodingKeys: String, CodingKey {
        case logId = "log_id"
        case dateCreated = "date_created"
        case logType = "log_type"
        case logCreator = "log_creator"
        case logTarget = "log_owner"
        case amount = "amount"
        case reason
    }

    public init(
        logId: String, dateCreated: String, logType: GroupLogType, 
        logCreator: String, logTarget: String, amount: Int? = nil,
        reason: String? = nil
    ) {
        self.logId = logId
        self.dateCreated = dateCreated
        self.logType = logType
        self.logCreator = logCreator
        self.logTarget = logTarget
        self.amount = amount
        self.reason = reason
    }
}

// MARK: Mocks
extension GroupLog {
    public static var mockJoined = GroupLog(
        logId: "nQ5SBb4rN6zYPLXBJOej",
        dateCreated: "2020-04-29 05:49:30.864",
        logType: .joined,
        logCreator: "Log Owner",
        logTarget: "Log Creator",
        amount: 1000000
    )
    
    public static var mockRemoved = GroupLog(
        logId: "mo5Rz8AOPTHbPzjqOb8u",
        dateCreated: "2020-04-30 05:49:30.864",
        logType: .removed,
        logCreator: "Log Owner",
        logTarget: "Log Creator",
        amount: 1000000
    )
    
    public static var mockLoanGiven = GroupLog(
        logId: "mo5Rz8AOPTHbPzjqOb8u",
        dateCreated: "2020-04-30 05:49:30.864",
        logType: .loanGiven,
        logCreator: "Log Owner",
        logTarget: "Log Creator",
        amount: 500000
    )
    
    public static var mockLoanReturned = GroupLog(
        logId: "mo5Rz8AOPTHbPzjqOb8u",
        dateCreated: "2020-04-30 05:49:30.864",
        logType: .loanReturned,
        logCreator: "Log Owner",
        logTarget: "Log Creator",
        amount: 500000
    )
    
    public static var mockMonthlyFee = GroupLog(
        logId: "mo5Rz8AOPTHbPzjqOb8u",
        dateCreated: "2020-04-30 05:49:30.864",
        logType: .monthlyFee,
        logCreator: "Log Owner",
        logTarget: "Log Creator",
        amount: 500000
    )
    
    public static var mockExtra = GroupLog(
        logId: "mo5Rz8AOPTHbPzjqOb8u",
        dateCreated: "2020-04-30 05:49:30.864",
        logType: .extra,
        logCreator: "",
        logTarget: "Log Creator",
        amount: 500000,
        reason: "Reason Text For Extra"
    )
    
    public static var mockExpenses = GroupLog(
        logId: "mo5Rz8AOPTHbPzjqOb8u",
        dateCreated: "2020-04-30 05:49:30.864",
        logType: .expenses,
        logCreator: "",
        logTarget: "Log Creator",
        amount: 500000,
        reason: "Reason Text For Expenses"
    )
    
    public static var mockAddAmount = GroupLog(
        logId: "mo5Rz8AOPTHbPzjqOb8u",
        dateCreated: "2020-04-30 05:49:30.864",
        logType: .addAmount,
        logCreator: "Log Owner",
        logTarget: "Log Creator",
        amount: 500000
    )
    
    public static var mockDeductAmount = GroupLog(
        logId: "mo5Rz8AOPTHbPzjqOb8u",
        dateCreated: "2020-04-30 05:49:30.864",
        logType: .deductAmount,
        logCreator: "Log Owner",
        logTarget: "Log Creator",
        amount: 500000
    )
    
    public static var mockMadeAdmin = GroupLog(
        logId: "mo5Rz8AOPTHbPzjqOb8u",
        dateCreated: "2020-04-30 05:49:30.864",
        logType: .madeAdmin,
        logCreator: "Log Owner",
        logTarget: "Log Creator"
    )
    
    public static var mockRemovedAdmin = GroupLog(
        logId: "mo5Rz8AOPTHbPzjqOb8u",
        dateCreated: "2020-04-30 05:49:30.864",
        logType: .removedAdmin,
        logCreator: "Log Owner",
        logTarget: "Log Creator"
    )
}
