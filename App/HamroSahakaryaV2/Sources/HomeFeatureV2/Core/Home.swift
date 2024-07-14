import Foundation
import ComposableArchitecture
import UserApiClient
import UserSessionClient
import AnalyticsClient
import SharedModels
import NoticeFeatureV2

@Reducer
public struct Home {
    @Reducer(state: .equatable)
    public enum Destination {
        case alert(AlertState<Alert>)
        case notice(Notice)
        
        public enum Alert: Equatable { }
    }
    
    @ObservableState
    public struct State: Equatable {
        public init(user: User) {
            self.user = user
        }
        
        @Presents public var destination: Destination.State?
        public var user: User
        public var homeResponse: HomeResponse?
        public var isLoading: Bool = false
        public var isPullToRefresh: Bool = false
        public var chartSelectedUserId: UserId = ""
        
        private var selectedUser: User? {
            guard let homeResponse else { return nil }
            return homeResponse.allMembers.first { $0.id == chartSelectedUserId }
        }
        
        public var memberCount: String {
            guard let homeResponse else { return "0 Member" }
            return "\(homeResponse.allMembers.count) Members"
        }
        
        public var selectedUserAmount: String {
            guard let selectedUser else { return "" }
            return selectedUser.balance.jaCurrency
        }
        
        public var selectedUserName: String {
            guard let selectedUser else { return "" }
            return selectedUser.username
        }
    }
    
    public enum Action {
        case destination(PresentationAction<Destination.Action>)
        
        case onAppear
        case pulledToRefresh
        case noticeButtonTapped
        case fetchAllData
        case fetchAllDataResponse(Result<HomeResponse, Error>)
        case updateChartSelectedUserId(UserId)
    }
    
    public init() { }
    
    @Dependency(\.userApiClient) private var userApiClient
    @Dependency(\.userSessionClient) private var userSessionClient
    @Dependency(\.continuousClock) private var clock
    @Dependency(\.analyticsClient) private var analyticsClient
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                handleTrackingEvent(eventType: .screenView)
                guard state.homeResponse.isEmpty else { return .none }
                
                state.isLoading = true
                return .send(.fetchAllData)
                
            case .pulledToRefresh:
                handleTrackingEvent(eventType: .pulledToRefresh)
                
                state.isPullToRefresh = true
                return .run { send in
                    // Waiting 1 second so that user can see custom refresh.
                    try await clock.sleep(for: .seconds(1))
                    // start fetching logs.
                    await send(.fetchAllData)
                }
                
            case .noticeButtonTapped:
                guard let notice = state.homeResponse?.notice else { return .none }
                handleTrackingEvent(eventType: .tapNotice)
                
                state.destination = .notice(Notice.State(notice: notice))
                return .none
                
            case .fetchAllData:
                return .run { send in
                    await send(
                        .fetchAllDataResponse(
                            Result {
                                try await fetchAllData()
                            }
                        )
                    )
                }
                
            case .fetchAllDataResponse(.success(let homeResponse)):
                state.isLoading = false
                state.isPullToRefresh = false
                state.homeResponse = homeResponse
                state.chartSelectedUserId = setInitialChartSelectedUser(homeResponse: homeResponse, userId: state.user.id)
                if let updatedUser = userSessionClient.read() {
                    state.user = updatedUser
                }
                return .none
                
            case .fetchAllDataResponse(.failure(let error)):
                state.isLoading = false
                state.isPullToRefresh = false
                state.destination = .alert(.onError(error))
                return .none
                
            case .updateChartSelectedUserId(let userId):
                handleTrackingEvent(eventType: .tapGraph)
                
                state.chartSelectedUserId = userId
                return .none
                
            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

// MARK: Apis
extension Home {
    private func fetchAllData() async throws -> HomeResponse {
        async let _allMembers = userApiClient.fetchAllMembers()
        async let _groupDetail = userApiClient.fetchGroupDetail()
        async let _notice = userApiClient.fetchNotice()
        
        let (allMembers, groupDetail, notice) = try await (_allMembers, _groupDetail, _notice)
        return HomeResponse(allMembers: allMembers, groupDetail: groupDetail, notice: notice)
    }
}

// MARK: Chart + Helper
extension Home {
    private func setInitialChartSelectedUser(homeResponse: HomeResponse?, userId: UserId) -> UserId {
        guard let homeResponse else { return "" }
        let initialSelectedUser = homeResponse.allMembers.first { $0.id == userId }
        guard let initialSelectedUser else { return "" }
        return initialSelectedUser.id
    }
}

// Analytics
extension Home {
    enum EventType {
        case screenView
        case tapNotice
        case tapGraph
        case pulledToRefresh
        
        var event: Event {
            switch self {
            case .screenView:
                return .screenView
            case .tapNotice, .tapGraph:
                return .buttonTap
            case .pulledToRefresh:
                return .pullToRefresh
            }
        }
        
        var actionName: String {
            switch self {
            case .screenView: return ""
            case .tapNotice: return "notice"
            case .tapGraph: return "graph"
            case .pulledToRefresh: return ""
            }
        }
    }
    
    private func handleTrackingEvent(eventType: EventType) {
        let parameter = Parameter(screenName: "home_view", actionName: eventType.actionName)
        analyticsClient.trackEvent(event: eventType.event, parameter: parameter)
    }
}
