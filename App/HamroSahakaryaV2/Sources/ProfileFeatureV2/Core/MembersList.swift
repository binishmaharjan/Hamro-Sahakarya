import Foundation
import ComposableArchitecture
import SharedModels
import UserApiClient

@Reducer
public struct MembersList {
    @ObservableState
    public struct State: Equatable {
        public init() { }
        public init(members: [User]) {
            self.members = members
        }
        
        public var isLoading: Bool = false
        public var members: [User] = []
    }
    
    public enum Action: Equatable {
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
                return .none
                       }
        }
    }
}
