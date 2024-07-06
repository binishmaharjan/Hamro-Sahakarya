import Foundation
import SharedUIs
import SharedModels

extension ExtraOrExpenses {
    var title: String {
        switch self {
        case .extra: return #localized("Extra")
        case .expenses: return #localized("Expenses")
        }
    }
}
