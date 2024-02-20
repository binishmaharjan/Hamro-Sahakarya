import Foundation

extension String {
    /// Int value from string
    public var int: Int {
        let formatter = NumberFormatter()
        formatter.locale = .current
        return (formatter.number(from: self)?.intValue).safeUnwrap
    }
}
