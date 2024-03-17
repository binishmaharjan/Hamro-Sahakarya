import Foundation
import ComposableArchitecture
import SharedModels
import UserApiClient
import SharedUIs

@Reducer
public struct RemoveMember {
    @Reducer(state: .equatable)
    public enum Destination {
        case alert(AlertState<Alert>)
        
        public enum Alert: Equatable {
            case removeConfirmationTapped
        }
    }
    
    @ObservableState
    public struct State: Equatable {
        public init(admin: User) {
            self.admin = admin
        }
        
        @Presents var destination: Destination.State?
        var admin: User
        var members: [User] = []
        var memberSelect: MemberSelect.State = MemberSelect.State(members: [], mode: .membersOnly)
        var isLoading: Bool = false
        var isRemovingMember: Bool = false
        var isValidInput: Bool {
            return !memberSelect.selectedMembers.isEmpty
        }
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        case memberSelect(MemberSelect.Action)
        
        case onAppear
        case membersListResponse(Result<[User], Error>)
        case removeMemberTapped
        case removeMemberResponse(Result<Void, Error>)
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
            case.onAppear:
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

                // if refetch flag after the removing member is true, show alert
                if state.isRemovingMember {
                    state.isRemovingMember = false
                    state.destination = .alert(.onMemberRemoved())
                }
                
                return .none
                
            case .membersListResponse(.failure(let error)):
                state.isLoading = false
                state.destination = .alert(.onError(error))
                return .none
                
            case .removeMemberTapped:
                guard !state.memberSelect.selectedMembers.isEmpty else { return .none }
                state.destination = .alert(.removeMemberConfirmation())
                return .none
                
            case .destination(.presented(.alert(.removeConfirmationTapped))):
                guard !state.memberSelect.selectedMembers.isEmpty else { return .none }
                let targetMember = state.memberSelect.selectedMembers[0]
                state.isLoading = true
                return .run { [admin = state.admin] send in
                    await send(
                        .removeMemberResponse(
                            Result {
                                try await userApiClient.removeMember(
                                    admin,
                                    targetMember
                                )
                            }
                        )
                    )
                }
                
            case .removeMemberResponse(.success):
                // Creating flag to show alert after refetching member
                state.isRemovingMember = true
                return .run { send in
                    await send(
                        .membersListResponse(
                            Result {
                                try await userApiClient.fetchAllMembers()
                            }
                        )
                    )
                }
                
            case .removeMemberResponse(.failure(let error)):
                state.isLoading = false
                state.destination = .alert(.onError(error))
                return .none
                
            case .destination, .memberSelect, .binding:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

// MARK: AlertState
extension AlertState where Action == RemoveMember.Destination.Alert {
    static func removeMemberConfirmation() -> AlertState {
        AlertState {
            TextState(#localized("Remove Confirmation"))
        } actions: {
            ButtonState(role: .cancel) {
                TextState(#localized("Cancel"))
            }
            ButtonState(action: .removeConfirmationTapped) {
                TextState(#localized("Yes, Remove Member"))
            }
        } message: {
            TextState(#localized("Are you sure you want to remove this member? This action is irreversible and member data will be completed removed."))
        }
    }
    
    public static func onMemberRemoved() -> AlertState {
        AlertState {
            TextState(#localized("Success"))
        } actions: {
            ButtonState { TextState(#localized("Ok")) }
        } message: {
            TextState(#localized("The member has been removed successfully"))
        }
    }
}
