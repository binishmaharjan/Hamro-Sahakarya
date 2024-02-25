import Foundation
import ComposableArchitecture
import SharedModels
import UserApiClient
import SwiftHelpers

@Reducer
public struct AddMonthlyFee {
    @ObservableState
    public struct State: Equatable {
        public enum Field: Equatable {
            case amount
        }
        
        public init(admin: User) {
            self.admin = admin
        }
        public init(admin: User = .mock, members: [User]) {
            self.admin = admin
            self.members = members
        }
        
        @Presents var destination: Destination.State?
        var admin: User
        var isLoading: Bool = false
        var amount: String = ""
        var members: [User] = []
        var selectedMembers: [User] = []
        var focusedField: Field? = .amount
        var isValidInput: Bool {
            return amount.int > 0
        }
        
        func isAllMemberSelected() -> Bool {
            return selectedMembers.isEmpty
        }
        
        func isSelected(member: User) -> Bool {
            return selectedMembers.contains(member)
        }
    }
    
    public enum Action: BindableAction, Equatable {
        public enum SelectionType: Equatable {
            case all
            case member(User)
        }
        case destination(PresentationAction<Destination.Action>)
        case binding(BindingAction<State>)
        
        case onAppear
        case membersListResponse(TaskResult<[User]>)
        case rowSelected(SelectionType)
        case addMonthlyFeeTapped
        case addMonthlyResponse(TaskResult<VoidSuccess>)
    }
    
    public init() { }
    
    @Dependency(\.userApiClient) private var userApiClient
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
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
                state.destination = .alert(.onError(error))
                return .none
                
            case .rowSelected(.all):
                state.selectedMembers = []
                return .none
                
            case .rowSelected(.member(let member)):
                if let index = state.selectedMembers.firstIndex(of: member) {
                    state.selectedMembers.remove(at: index)
                } else {
                    state.selectedMembers.append(member)
                }
                return .none
                
            case .addMonthlyFeeTapped:
                state.isLoading = true
                return .run { [state = state] send in
                    let targetMembers = state.selectedMembers.isEmpty ? state.members: state.selectedMembers
                    
                    await send(
                        .addMonthlyResponse(
                            TaskResult {
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
                
            case .binding, .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination()
        }
    }
}

// MARK: Apis
extension AddMonthlyFee {
    /// Add monthly fee for multiple users. (Hit multiple api in parallel)
    private func addMonthlyFee(admin: User, members: [User], amount: Balance) async throws -> VoidSuccess {
        // Create a task group to run multiple apis
        try await withThrowingTaskGroup(of: Void.self) { group in
            for member in members {
                group.addTask {
                    // Hit multiple apis
                    try await userApiClient.addMonthlyFee(admin, member, amount)
                }
            }
            // Wait for all task to complete
            for try await _ in group { }
            
            return VoidSuccess()
        }
    }
}

// MARK: Destination
extension AddMonthlyFee {
    @Reducer
    public struct Destination {
        public enum State: Equatable {
            case alert(AlertState<Action.Alert>)
        }
        
        public enum Action: Equatable {
            public enum Alert: Equatable {}
            
            case alert(Alert)
        }
        
        public init() { }
        
        public var body: some ReducerOf<Self> {
            Reduce<State, Action> { state, action in
                return .none
            }
        }
    }
}
