import Foundation

public struct NewUser: Codable {
    public let username: String
    public let email: String
    public let status: Status
    public let colorHex: String
    public let dateCreated: String
    public let keyword: String
    public let initialAmount: Int

    public init(username: String, email: String, status: Status, colorHex: String, dateCreated: String, keyword: String, initialAmount: Int) {
        self.username = username
        self.email = email
        self.status = status
        self.colorHex = colorHex
        self.dateCreated = dateCreated
        self.keyword = keyword
        self.initialAmount = initialAmount
    }
}

// MARK: Account Creation
extension NewUser {
    public func createAccount(with id: UserId) -> User {
        User(
            id: id,
            username: username,
            email: email,
            status: status,
            colorHex: colorHex,
            iconUrl: "",
            dateCreated: Date().toString,
            keyword: keyword,
            loanTaken: 0,
            balance: initialAmount,
            dateUpdated: Date().toString
        )
    }
}
