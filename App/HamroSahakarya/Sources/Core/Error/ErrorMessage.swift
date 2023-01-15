import Foundation

public struct ErrorMessage: Error {
    // MARK: Properties
    public let id: UUID
    public let title: String
    public let message: String

    public init(title: String, message: String) {
        self.id = UUID()
        self.title = title
        self.message = message
    }
}


extension ErrorMessage: Equatable {

    public static func ==(lhs: ErrorMessage, rhs: ErrorMessage) -> Bool {
        return lhs.id == rhs.id
    }
}
