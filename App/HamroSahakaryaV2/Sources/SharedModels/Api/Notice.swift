import Foundation

public struct Notice: Codable {
    public let message: String
    public let admin: String
    public let dateCreated: String

    private enum CodingKeys: String, CodingKey {
        case message
        case admin
        case dateCreated = "date_created"
    }

    public init(message: String, admin: String, dateCreated: String) {
        self.message = message
        self.admin = admin
        self.dateCreated = dateCreated
    }

    // MARK: Static Instances
    public static var blankNotice = Notice(message: "", admin: "", dateCreated: "")
}
