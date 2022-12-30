import Foundation

/// Data Model for the Drop Down Notification
public struct DropDownModel {
    public let dropDownType: DropDownType
    public let message: String

    public init(dropDownType: DropDownType, message: String) {
        self.dropDownType = dropDownType
        self.message = message
    }

    // MARK: Static Instances
    static let defaultDropDown = DropDownModel(dropDownType: .normal, message: "Default Drop Down")
}


public enum DropDownType {
  case error
  case success
  case normal


//  var backroundColor: UIColor {
//    switch self {
//    case .error:
//      return .red_50
//    case .success:
//      return .green_50
//    case .normal:
//      return .mainBlack_50
//    }
//  }
}
