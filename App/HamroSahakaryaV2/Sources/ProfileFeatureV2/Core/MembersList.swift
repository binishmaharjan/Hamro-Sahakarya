import Foundation
import ComposableArchitecture
import SharedModels
import SharedUIs
import UserApiClient
import AnalyticsClient

@Reducer
public struct MembersList {
    @Reducer(state: .equatable)
    public enum Destination {
        case alert(AlertState<Alert>)
        
        public enum Alert: Equatable { }
    }
    
    @ObservableState
    public struct State: Equatable {
        public init() { }
        public init(members: [User]) {
            self.members = members
        }
        
        @Presents public var destination: Destination.State?
        public var isLoading: Bool = false
        public var members: [User] = []
    }
    
    public enum Action {
        case destination(PresentationAction<Destination.Action>)
        
        case onAppear
        case fetchMembersList
        case membersListResponse(Result<[User], Error>)
    }
    
    public init() { }
    
    @Dependency(\.userApiClient) private var userApiClient
    @Dependency(\.analyticsClient) private var analyticsClient
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                handleTrackingEvent(eventType: .screenView)
                return .send(.fetchMembersList)
                
            case .fetchMembersList:
                state.isLoading = true
                return .run { send in
                    await send(
                        .membersListResponse(
                            Result {
                                try await userApiClient.fetchAllMembers()
                            }
                        )
                    )
                }
                
            case .membersListResponse(.success(let members)):
                state.isLoading = false
                state.members = members
                return .none
                
            case .membersListResponse(.failure(let error)):
                state.isLoading = false
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
extension MembersList {
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
        let parameter = Parameter(screenName: "mebmer_list_view", actionName: eventType.actionName)
        analyticsClient.trackEvent(event: eventType.event, parameter: parameter)
    }
}
