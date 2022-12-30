import Foundation

public struct ErrorMessage: Error {
    // MARK: Properties
    let id: UUID
    let title: String
    let message: String

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
