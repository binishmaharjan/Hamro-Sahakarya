import Foundation
import FirebaseAnalytics

public enum ParameterKey: String {
    case actionName = "action_name"
}

public enum Event {
    case buttonTap
    case confirmationSelect
    case pullToRefresh
    case screenView
    
    var key: String {
        switch self {
        case .buttonTap: return "button_tap"
        case .confirmationSelect: return "confirmation_select"
        case .pullToRefresh: return "pull_to_refresh"
        case .screenView: return AnalyticsEventScreenView
        }
    }
}
