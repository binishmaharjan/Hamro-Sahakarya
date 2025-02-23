import Foundation
import ComposableArchitecture
import AnalyticsClient

@Reducer
public struct License {
    @ObservableState
    public struct State: Equatable {
        public init() { }
        var licenses = LicensePlugin.licenses
    }
    
    public enum Action {
        case onAppear
    }
    
    @Dependency(\.analyticsClient) private var analyticsClient
    
    public init() { }
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                handleTrackingEvent(eventType: .screenView)
                return .none
            }
        }
    }
}

// Analytics
extension License {
    enum EventType {
        case screenView
        
        var event: Event {
            switch self {
            case .screenView:
                return .screenView
            }
        }
        
        var actionName: String {
            switch self {
            case .screenView: return ""
            }
        }
    }
    
    private func handleTrackingEvent(eventType: EventType) {
        let parameter = Parameter(screenName: "license_view", actionName: eventType.actionName)
        analyticsClient.trackEvent(event: eventType.event, parameter: parameter)
    }
}
