import Core
import Foundation
import UIKit

extension DropDownType {
   public var backgroundColor: UIColor {
        switch self {
        case .error:
            return .red_50
        case .success:
            return .green_50
        case .normal:
            return .mainBlack_50
        }
    }
}
