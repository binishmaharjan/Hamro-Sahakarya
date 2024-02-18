import Foundation
import ComposableArchitecture
import SharedModels
import SharedUIs
import UserApiClient

@Reducer
public struct MembersList {
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
    
    public enum Action: Equatable {
        case destination(PresentationAction<Destination.Action>)
        
        case onAppear
        case fetchMembersList
        case membersListResponse(TaskResult<[User]>)
    }
    
    public init() { }
    
    @Dependency(\.userApiClient) private var userApiClient
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                return .send(.fetchMembersList)
                
            case .fetchMembersList:
                state.isLoading = true
                return .run { send in
                    await send(
                        .membersListResponse(
                            TaskResult {
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
                state.destination = .alert(.fetchLMembersListFailed(error))
                return .none
                
            case .destination:
                return .none
            }
        }
    }
}

// MARK: Destination
extension MembersList {
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

// MARK: AlertState
extension AlertState where Action == MembersList.Destination.Action.Alert {
    static func fetchLMembersListFailed(_ error: Error) -> AlertState {
        AlertState {
            TextState(#localized("Error"))
        } actions: {
            ButtonState { TextState(#localized("Ok")) }
        } message: {
            TextState(error.localizedDescription)
        }
    }
}
