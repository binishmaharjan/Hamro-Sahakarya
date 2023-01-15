import Core
import Foundation

public enum MainView {
    case launching
    case onboarding
    case signedIn(userSession: UserSession)
}

extension MainView: Equatable {
    public static func ==(lhs: MainView, rhs: MainView) -> Bool {
        switch (lhs, rhs) {
        case (.launching, .launching):
            return true
        case (.onboarding, .onboarding):
            return true
        case let (.signedIn(l), .signedIn(r)):
            return l == r
        default:
            return false
        }
    }
}
