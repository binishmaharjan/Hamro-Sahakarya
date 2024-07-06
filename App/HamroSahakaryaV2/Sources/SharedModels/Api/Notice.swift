import Foundation

public struct NoticeInfo: Codable, Equatable {
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
    public static var blankNotice = NoticeInfo(message: "", admin: "", dateCreated: "")
    public static var mock = NoticeInfo(message: "Next meeting 2024/06/30 Sunday 13:00 At Saginomiya Park Thank you.", admin: "John Appleseed", dateCreated: "2020-05-26 12:56:12.068")
}
