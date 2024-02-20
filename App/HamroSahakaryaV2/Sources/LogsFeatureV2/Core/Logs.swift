import Foundation
import ComposableArchitecture
import SharedModels
import SharedUIs
import UserApiClient

@Reducer
public struct Logs {
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
    
    public enum Action: Equatable {
        case destination(PresentationAction<Destination.Action>)
        
        case onAppear
        case pulledToRefresh
        case scrolledToTop
        case tabBarTapped
        case fetchLogs
        case logsResponse(TaskResult<[GroupLog]>)
    }
    
    public init() { }
    
    @Dependency(\.userApiClient) private var userApiClient
    @Dependency(\.continuousClock) private var clock
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                guard state.logs.isEmpty else { return .none }
                state.isLoading = true
                return .send(.fetchLogs)
                
            case .pulledToRefresh:
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
                            TaskResult {
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
        .ifLet(\.$destination, action: \.destination) {
            Destination()
        }
    }
}

// MARK: Destination
extension Logs {
    @Reducer
    public struct Destination {
        @ObservableState
        public enum State: Equatable {
            case alert(AlertState<Action.Alert>)
        }
        
        public enum Action: Equatable {
            public enum Alert: Equatable {}
            case alert(Alert)
        }
        
        public var body: some ReducerOf<Self> {
            Reduce { state, action in
                return .none
            }
        }
    }
}
