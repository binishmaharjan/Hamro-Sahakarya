import Foundation

public typealias UserId = String
public typealias Email = String
public typealias Password = String
public typealias ImageUrl = String
public typealias ColorHex = String
public typealias Balance = Int
public typealias Loan = Int

public struct User: Equatable, Identifiable, Codable {
    public let id: UserId
    public let username: String
    public let email: String
    public let status: Status
    public let colorHex: ColorHex
    public let iconUrl: ImageUrl?
    public let dateCreated: String
    public let keyword: String

    // Account
    public let loanTaken: Int
    public let balance: Int
    public let dateUpdated: String

    private enum CodingKeys: String, CodingKey {
        case id = "uid"
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

    public init(
        id: String, username: String, email: String,
        status: Status, colorHex: String, iconUrl: String? = nil,
        dateCreated: String, keyword: String,
        loanTaken: Int, balance: Int, dateUpdated: String
    ) {
        self.id = id
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

// MARK: No User
extension User {
    /// Represent no user user data
    static let none: User? = nil
}

// MARK: Mock Data
extension User {
    public static let mock = User(
        id: "0",
        username: "username",
        email: "email@gmail.com",
        status: .member,
        colorHex: "#FFFFFF",
        dateCreated: "2024-01-01 22:00:00.000",
        keyword: "keyword",
        loanTaken: 0,
        balance: 0,
        dateUpdated: "2024-01-01 22:00:00.000"
    )
    
    /// Mock member representing all members
    public static let allMember = User(
        id: "0",
        username: "All Members",
        email: "",
        status: .member,
        colorHex: "",
        dateCreated: "2024-01-01 22:00:00.000",
        keyword: "keyword",
        loanTaken: 0,
        balance: 0,
        dateUpdated: "2024-01-01 22:00:00.000"
    )
}
