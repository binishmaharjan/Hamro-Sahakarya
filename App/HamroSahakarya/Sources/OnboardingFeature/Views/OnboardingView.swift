import Foundation

public enum OnboardingView {
    case signIn
    case signUp
    
    public var hidesNavigationBar: Bool {
        switch self {
        case .signIn:
            return false
        case .signUp:
            return false
        }
    }
}
