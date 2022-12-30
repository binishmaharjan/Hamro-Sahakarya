import Foundation

// MARK: Date To String
extension Date {
    public var toString: String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return formatter.string(from: self)
    }

    public var toGegorianMonthDateYearString: String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter.string(from: self)
    }

}

// MARK: String To Date
extension String {
    public var toDateAndTime: Date {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        if let date = formatter.date(from: self) {
            return date
        } else {
            return Date()
        }
    }

    public var toDate: Date {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: self) {
            return date
        } else {
            return Date()
        }
    }
}
