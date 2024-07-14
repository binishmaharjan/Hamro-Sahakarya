import Foundation
import ComposableArchitecture
import FirebaseAnalytics

// MARK: Dependency (liveValue)
extension AnalyticsClient: DependencyKey {
    public static let liveValue = Self.live()
}

// MARK: - Live Implementation
extension AnalyticsClient {
    public static func live() -> Self {
        func trackEvent(event: Event, parameter: Parameter) {
            let parameters = getParameters(parameter)
            Analytics.logEvent(event.key, parameters: parameters)
        }

        func getParameters(_ paramter: Parameter) -> [String: String] {
            var parameters: [String: String] = [
                AnalyticsParameterScreenClass: paramter.screenName,
                AnalyticsParameterScreenName: paramter.screenName
            ]
            if let actionName = paramter.actionName, !actionName.isEmpty {
                parameters.updateValue(actionName, forKey: ParameterKey.actionName.rawValue)
            }
            return parameters
        }
        
        return  AnalyticsClient(
            trackEvent: { trackEvent(event: $0, parameter: $1) }
        )
    }
}
