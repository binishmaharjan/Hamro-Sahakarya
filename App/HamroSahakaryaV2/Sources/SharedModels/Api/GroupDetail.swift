import Foundation

public struct GroupDetail: Equatable, Codable {
    public let extra: Int
    public let expenses: Int

    public init(extra: Int, expenses: Int) {
        self.extra = extra
        self.expenses = expenses
    }
}

