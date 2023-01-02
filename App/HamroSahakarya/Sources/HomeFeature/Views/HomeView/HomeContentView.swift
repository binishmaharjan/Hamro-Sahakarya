import UIKit

public enum HomeContentView: Int {
    case memberGraph
    case accountDetail
    case notice
    
    public var title: String {
        switch self {
        case .accountDetail:
            return "Account Detail"
        case .memberGraph:
            return "Member Graph"
        case .notice:
            return "Notice"
        }
    }
    
    public var index: Int {
        switch self {
        case .accountDetail:
            return 1
        case .memberGraph:
            return 0
        case .notice:
            return 2
        }
    }
}
