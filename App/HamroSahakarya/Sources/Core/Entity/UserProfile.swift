import Foundation

public struct UserProfile: Equatable, Codable {
    public let uid: String
    public let username: String
    public let email: String
    public let status: Status
    public let colorHex: String
    public let iconUrl: String?
    public let dateCreated: String
    public let keyword: String

    //Account
    public let loanTaken: Int
    public let balance: Int
    public let dateUpdated: String

    private enum CodingKeys: String, CodingKey {
        case uid
        case username
        case email
        case status
        case colorHex = "color_hex"
        case iconUrl = "icon_url"
        case dateCreated = "date_created"
        case loanTaken = "loan_taken"
        case balance
        case dateUpdated = "data_updated"
        case keyword
    }

    public init(uid: String, username: String, email: String, status: Status, colorHex: String, iconUrl: String? = nil, dateCreated: String, keyword: String, loanTaken: Int, balance: Int, dateUpdated: String) {
        self.uid = uid
        self.username = username
        self.email = email
        self.status = status
        self.colorHex = colorHex
        self.iconUrl = iconUrl
        self.dateCreated = dateCreated
        self.keyword = keyword
        self.loanTaken = loanTaken
        self.balance = balance
        self.dateUpdated = dateUpdated
    }
}

