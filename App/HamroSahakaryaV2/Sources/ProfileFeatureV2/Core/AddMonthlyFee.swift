import Foundation
import ComposableArchitecture
import SharedModels
import UserApiClient
import SwiftHelpers

@Reducer
public struct AddMonthlyFee {
    @Reducer(state: .equatable)
    public enum Destination {
        case alert(AlertState<Alert>)
        
        public enum Alert: Equatable { }
    }
    
    @ObservableState
    public struct State: Equatable {
        public init(admin: User) {
            self.admin = admin
        }
        /// For preview
        init(admin: User = .mock, members: [User]) {
            self.admin = admin
            self.members = members
        }
        
        @Presents var destination: Destination.State?
        var memberSelect: MemberSelect.State = MemberSelect.State(members: [], mode: .all)
        var admin: User
        var isLoading: Bool = false
        var amount: String = ""
        var members: [User] = []
        var isValidInput: Bool {
            return amount.int > 0
        }
    }
    
    public enum Action: BindableAction {
        case destination(PresentationAction<Destination.Action>)
        case binding(BindingAction<State>)
        case memberSelect(MemberSelect.Action)
        
        case onAppear
        case membersListResponse(Result<[User], Error>)
        case addMonthlyFeeTapped
        case addMonthlyResponse(Result<Void, Error>)
    }
    
    public init() { }
    
    @Dependency(\.userApiClient) private var userApiClient
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.memberSelect, action: \.memberSelect) {
            MemberSelect()
        }
        
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                guard state.members.isEmpty else { return .none }
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
                state.memberSelect = MemberSelect.State(members: members, mode: .all)
                return .none
                
            case .membersListResponse(.failure(let error)):
                state.isLoading = false
                state.destination = .alert(.onError(error))
                return .none
                
            case .addMonthlyFeeTapped:
                state.isLoading = true
                return .run { [state = state] send in
                    let targetMembers = state.memberSelect.selectedMembers.isEmpty
                    ? state.members
                    : state.memberSelect.selectedMembers
                    
                    await send(
                        .addMonthlyResponse(
                            Result {
                                try await addMonthlyFee(
                                    admin: state.admin,
                                    members: targetMembers,
                                    amount: state.amount.int
                                )
                            }
                        )
                    )
                }
                
            case .addMonthlyResponse(.success):
                state.isLoading = false
                state.amount = ""
                state.destination = .alert(.onUpdateSuccessful())
                return .none
                
            case .addMonthlyResponse(.failure(let error)):
                state.isLoading = false
                state.destination = .alert(.onError(error))
                return .none
                
            case .binding, .destination, .memberSelect:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

// MARK: Apis
extension AddMonthlyFee {
    /// Add monthly fee for multiple users. (Hit multiple api in parallel)
    private func addMonthlyFee(admin: User, members: [User], amount: Balance) async throws -> Void {
        // Create a task group to run multiple apis
        try await withThrowingTaskGroup(of: Void.self) { group in
            for member in members {
                group.addTask {
                    // Hit multiple apis
                    try await userApiClient.addMonthlyFee(by: admin, user: member, balance: amount)
                }
            }
            // Wait for all task to complete
            for try await _ in group { }
            
            return Void()
        }
    }
}
