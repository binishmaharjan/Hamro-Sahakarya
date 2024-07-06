import Foundation

public enum DateFormat: String {
    case dateTime = "yyyy-MM-dd HH:mm:ss.SSS"
    case dateOnly = "yyyy-MM-dd"
    case monthYear = "MMMM yyyy"
    case monthDateYear = "MMM dd, yyyy"
}

// MARK: Date To String
extension Date {
    public func toString(for format: DateFormat) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = format.rawValue
        return formatter.string(from: self)
    }
}

// MARK: String To Date
extension String {
    public func toDate(for format: DateFormat) -> Date {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = format.rawValue
        if let date = formatter.date(from: self) {
            return date
        } else {
            return Date()
        }
    }
}
