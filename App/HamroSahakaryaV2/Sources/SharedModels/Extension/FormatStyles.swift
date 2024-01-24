import Foundation

// MARK: Currency Format
public struct CurrencyFormatStyle: FormatStyle {
    public func format(_ value: Int) -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale(identifier: "ja_JP")
        return currencyFormatter.string(for: self) ?? "¥0"
    }
}

extension FormatStyle where Self == CurrencyFormatStyle {
    public static var jaCurrency: CurrencyFormatStyle { CurrencyFormatStyle() }
}

extension Int {
    public var jaCurrency: String {
        // TODO: Returns ¥0. Why?
//        self.formatted(.jaCurrency)
        self.formatted(.currency(code: "JPY"))
    }
}

// MARK: Log Date Format
public struct LogDateFormatStyle: FormatStyle {
    public func format(_ value: Date) -> String {
        let formatter = DateFormatter()
        formatter.doesRelativeDateFormatting = true
        formatter.timeStyle = .short
        formatter.dateStyle = .full
        return formatter.string(from: value)
    }
}

extension FormatStyle where Self == LogDateFormatStyle {
    public static var logDate: LogDateFormatStyle { .init() }
}
