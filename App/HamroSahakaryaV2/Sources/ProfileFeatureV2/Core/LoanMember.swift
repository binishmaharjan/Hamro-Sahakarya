import Foundation
import ComposableArchitecture
import SharedModels
import UserApiClient

@Reducer
public struct LoanMember {
    @Reducer(state: .equatable)
    public enum Destination {
        case alert(AlertState<Alert>)
        
        public enum Alert: Equatable { }
    }
    
    @ObservableState
    public struct State: Equatable {
        public enum Field: Equatable {
            case amount
        }
        public init(admin: User) {
            self.admin = admin
        }
        
        @Presents var destination: Destination.State?
        var admin: User
        var memberSelect: MemberSelect.State = MemberSelect.State(members: [], mode: .membersOnly)
        var isLoading: Bool = false
        var amount: String = ""
        var members: [User] = []
        var focusedField: Field? = .amount
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
        case loanMemberTapped
        case loanMemberResponse(Result<Void, Error>)
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
                state.memberSelect = MemberSelect.State(members: members, mode: .membersOnly)
                return .none
                
            case .membersListResponse(.failure(let error)):
                state.isLoading = false
                state.destination = .alert(.onError(error))
                return .none
                
            case .loanMemberTapped:
                state.isLoading = true
                return .run { [state = state] send in
                    await send(
                        .loanMemberResponse(
                            Result {
                                try await userApiClient.loanGiven(
                                    by: state.admin,
                                    user: state.memberSelect.selectedMembers[0],
                                    loan: state.amount.int
                                )
                            }
                        )
                    )
                }
                
            case .loanMemberResponse(.success):
                state.isLoading = false
                state.amount = ""
                state.destination = .alert(.onUpdateSuccessful())
                return .none
                
            case .loanMemberResponse(.failure(let error)):
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
