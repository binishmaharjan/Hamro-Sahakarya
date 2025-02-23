import Foundation
import ComposableArchitecture
import SharedModels
import SharedUIs
import AnalyticsClient

@Reducer
public struct LoanReturned {
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
        
        @Presents var destination: Destination.State?
        var admin: User
        var memberSelect: MemberSelect.State = MemberSelect.State(members: [], mode: .membersOnly)
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
        case loanReturnedTapped
        case loanReturnedResponse(Result<Void, Error>)
    }
    
    public init() { }
    
    @Dependency(\.userApiClient) private var userApiClient
    @Dependency(\.analyticsClient) private var analyticsClient
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.memberSelect, action: \.memberSelect) {
            MemberSelect()
        }
        
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                handleTrackingEvent(eventType: .screenView)
                guard state.members.isEmpty else { return .none }

                state.isLoading = true
                return .run { send in
                    await send(
                        .membersListResponse(
                            Result {
                                try await userApiClient.fetchAllMembersWithLoan()
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
                
            case .loanReturnedTapped:
                // If no user is selected, do nothing
                guard !state.memberSelect.selectedMembers.isEmpty else { return .none }
                
                // If loan returned is greater than loan taken, show error
                guard state.amount.int <= state.memberSelect.selectedMembers[0].loanTaken else {
                    state.destination = .alert(.onLoanAmountOverError())
                    return .none
                }
                
                // If user  is developer, show alert
                guard state.admin.isUseAdminMenu else {
                    state.destination = .alert(.onNoPermissionAlert())
                    return .none
                }
                
                state.isLoading = true
                return .run { [state = state] send in
                    await send(
                        .loanReturnedResponse(
                            Result {
                                try await userApiClient.loanReturned(
                                    by: state.admin,
                                    user: state.memberSelect.selectedMembers[0],
                                    loan: state.amount.int
                                )
                            }
                        )
                    )
                }
                
            case .loanReturnedResponse(.success):
                state.isLoading = false
                state.amount = ""
                state.destination = .alert(.onUpdateSuccessful())
                return .none
                
            case .loanReturnedResponse(.failure(let error)):
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

// MARK: AlertState
extension AlertState where Action == LoanReturned.Destination.Alert {
    public static func onLoanAmountOverError() -> AlertState {
        AlertState {
            TextState(#localized("Error"))
        } actions: {
            ButtonState { TextState(#localized("Ok")) }
        } message: {
            TextState(#localized("The loan amount is more than loan taken."))
        }
    }
}

// Analytics
extension LoanReturned {
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
        let parameter = Parameter(screenName: "loan_returned_view", actionName: eventType.actionName)
        analyticsClient.trackEvent(event: eventType.event, parameter: parameter)
    }
}
