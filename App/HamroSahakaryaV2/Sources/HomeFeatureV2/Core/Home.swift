import Foundation
import ComposableArchitecture
import UserApiClient
import SharedModels

@Reducer
public struct Home {
    @Reducer(state: .equatable)
    public enum Destination {
        case alert(AlertState<Alert>)
        
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
        case fetchAllData
        case fetchAllDataResponse(Result<HomeResponse, Error>)
        case updateChartSelectedUserId(UserId)
    }
    
    public init() { }
    
    @Dependency(\.userApiClient) private var userApiClient
    @Dependency(\.continuousClock) private var clock
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                guard state.homeResponse.isEmpty else { return .none }
                state.isLoading = true
                return .send(.fetchAllData)
                
            case .pulledToRefresh:
                state.isPullToRefresh = true
                return .run { send in
                    // Waiting 1 second so that user can see custom refresh.
                    try await clock.sleep(for: .seconds(1))
                    // start fetching logs.
                    await send(.fetchAllData)
                }
                
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
                return .none
                
            case .fetchAllDataResponse(.failure(let error)):
                state.isLoading = false
                state.isPullToRefresh = false
                state.destination = .alert(.onError(error))
                return .none
                
            case .updateChartSelectedUserId(let userId):
                state.chartSelectedUserId = userId
                return .none
                
            case .destination:
                return .none
            }
        }
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
