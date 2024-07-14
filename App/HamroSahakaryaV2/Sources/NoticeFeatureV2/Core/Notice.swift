import Foundation
import ComposableArchitecture
import SharedModels
import AnalyticsClient

@Reducer
public struct Notice {
    @ObservableState
    public struct State: Equatable {
        public init(notice: NoticeInfo) {
            self.notice = notice
        }
        
        public var notice: NoticeInfo
    }
    
    public enum Action {
        case doNotShowAgainChecked
        case okButtonTapped
        case onAppear
    }
    
    public init() { }
    
    @Dependency(\.dismiss) private var dismiss
    @Dependency(\.analyticsClient) private var analyticsClient
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                handleTrackingEvent(eventType: .screenView)
                return .none
            case .doNotShowAgainChecked:
                return .none
                
            case .okButtonTapped:
                return .run { _ in
                    await dismiss()
                }
            }
        }
    }
}

// Analytics
extension Notice {
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
        let parameter = Parameter(screenName: "notice_view", actionName: eventType.actionName)
        analyticsClient.trackEvent(event: eventType.event, parameter: parameter)
    }
}
