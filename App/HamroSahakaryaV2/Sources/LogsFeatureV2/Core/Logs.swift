import Foundation
import ComposableArchitecture
import SharedModels
import SharedUIs
import UserApiClient
import AnalyticsClient

@Reducer
public struct Logs {
    @Reducer(state: .equatable)
    public enum Destination {
        case alert(AlertState<Alert>)
        
        public enum Alert: Equatable { }
    }
    
    @ObservableState
    public struct State: Equatable {
        public init() { }
        
        @Presents public var destination: Destination.State?
        public var logs: [GroupLog] = []
        public var groupedLogs: [GroupedLogs] = []
        public var isLoading: Bool = false
        public var isPullToRefresh: Bool = false
        public var needsScrollToTop: Bool = false
    }
    
    public enum Action {
        case destination(PresentationAction<Destination.Action>)
        
        case onAppear
        case pulledToRefresh
        case scrolledToTop
        case tabBarTapped
        case fetchLogs
        case logsResponse(Result<[GroupLog], Error>)
    }
    
    public init() { }
    
    @Dependency(\.userApiClient) private var userApiClient
    @Dependency(\.continuousClock) private var clock
    @Dependency(\.analyticsClient) private var analyticsClient
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                handleTrackingEvent(eventType: .screenView)
                guard state.logs.isEmpty else { return .none }
                
                state.isLoading = true
                return .send(.fetchLogs)
                
            case .pulledToRefresh:
                handleTrackingEvent(eventType: .pullToRefresh)
                
                state.isPullToRefresh = true
                return .run { send in
                    // Waiting 1 second so that user can see custom refresh.
                    try await clock.sleep(for: .seconds(1))
                    // start fetching logs.
                    await send(.fetchLogs)
                }
                
            case .tabBarTapped:
                state.needsScrollToTop = true
                return .none
                
            case .scrolledToTop:
                state.needsScrollToTop = false
                return .none
                
            case .fetchLogs:
                return .run { send in
                    await send(
                        .logsResponse(
                            Result {
                                try await userApiClient.fetchLogs()
                            }
                        )
                    )
                }
                
            case .logsResponse(.success(let logs)):
                state.isLoading = false
                state.isPullToRefresh = false
                state.logs = logs
                state.groupedLogs = logs.groupByYearAndMonth()
                return .none
                
            case .logsResponse(.failure(let error)):
                state.isLoading = false
                state.isPullToRefresh = false
                state.destination = .alert(.onError(error))
                return .none
                
            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

// Analytics
extension Logs {
    enum EventType {
        case screenView
        case pullToRefresh
        
        var event: Event {
            switch self {
            case .screenView: return .screenView
            case .pullToRefresh: return .pullToRefresh
            }
        }
        
        var actionName: String {
            switch self {
            case .screenView, .pullToRefresh: return ""
            }
        }
    }
    
    private func handleTrackingEvent(eventType: EventType) {
        let parameter = Parameter(screenName: "logs_view", actionName: eventType.actionName)
        analyticsClient.trackEvent(event: eventType.event, parameter: parameter)
    }
}
