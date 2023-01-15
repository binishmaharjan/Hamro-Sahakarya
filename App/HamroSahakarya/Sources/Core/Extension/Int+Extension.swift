import Foundation

extension Int {
    public var currency: String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale(identifier: "ja_JP")
        return currencyFormatter.string(for: self) ?? "¥0"
    }
}
