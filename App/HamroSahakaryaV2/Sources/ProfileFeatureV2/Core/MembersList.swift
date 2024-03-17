import Foundation
import ComposableArchitecture
import SharedModels
import SharedUIs
import UserApiClient

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
