import UIKit

public enum AppColor: String, CaseIterable {
    // #cEF5D0B
    case mainOrange = "cEF5D0B"
    // #cEF5D0B@50
    case mainOrange_50 = "cEF5D0B@50"
    // #cEF5D0B@70
    case mainOrange_70 = "cEF5D0B@70"
    // #c5983AC
    case mainBlue = "c5983AC"
    // #c241D1D
    case mainBlack = "c241D1D"
    // #cADB2B6
    case textGray = "cADB2B6"
    // #cFAFBFD
    case backgroundGray = "cFAFBFD"
    // #cFF3A2F@50
    case red_50 = "cFF3A2F@50"
    // #c00F900@50
    case green_50 = "c00F900@50"
    // #c241D1D@50
    case mainBlack_50 = "c241D1D@50"
    // #c241D1D@30
    case mainBlack_30 = "c241D1D@30"
}

extension UIColor {
    public convenience init(_ appColor: AppColor) {
        self.init(named: appColor.rawValue, in: .module, compatibleWith: nil)!
    }

    public static func app(_ appColor: AppColor) -> UIColor {
        UIColor(appColor)
    }
}

extension UIColor {

    // MARK: Predefined Colors
    public static let mainOrange = UIColor(.mainOrange)
    public static let mainOrange_50 = UIColor(.mainOrange_50)
    public static let mainOrange_70 = UIColor(.mainOrange_70)
    public static let mainBlue = UIColor(.mainBlue)
    public static let mainBlack = UIColor(.mainBlack)
    public static let textGray = UIColor(.textGray)
    public static let backgroundGray = UIColor(.backgroundGray)
    
    // MARK: Predefined Transparent Colors
    public static let red_50 = UIColor(.red_50)
    public static let green_50 = UIColor(.green_50)
    public static let mainBlack_50 = UIColor(.mainBlack_50)
    public static let mainBlack_30 = UIColor(.mainBlack_30)
}
