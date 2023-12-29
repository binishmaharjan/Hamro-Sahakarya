import Foundation

public struct GroupLog: Codable, Equatable {
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
        case amount
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
