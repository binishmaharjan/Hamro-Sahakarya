import Foundation
import ComposableArchitecture
import SharedModels
import SharedUIs
import AnalyticsClient

@Reducer
public struct AddOrDeductAmount {
    @Reducer(state: .equatable)
    public enum Destination {
        case confirmationDialog(ConfirmationDialogState<ConfirmationDialog>)
        case alert(AlertState<Alert>)
        
        public enum Alert: Equatable { }
        public enum ConfirmationDialog: Equatable {
            case addTapped
            case deductTapped
        }
    }
    
    @ObservableState
    public struct State: Equatable {
        public init(admin: User) {
            self.admin = admin
        }
        
        @Presents var destination: Destination.State?
        var admin: User
        var memberSelect: MemberSelect.State = MemberSelect.State(members: [], mode: .membersOnly)
        var type: AddOrDeduct = .add
        var members: [User] = []
        var amount: String = ""
        var isLoading: Bool = false
        
        var isValidInput: Bool {
            return amount.int > 0
        }
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        case memberSelect(MemberSelect.Action)
        
        case onAppear
        case membersListResponse(Result<[User], Error>)
        case typeFieldTapped
        case updateButtonTapped
        case addOrDeductAmountResponse(Result<Void, Error>)
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
                
            case .typeFieldTapped:
                state.destination = .confirmationDialog(.selectType)
                return .none
                
            case .destination(.presented(.confirmationDialog(let option))):
                state.destination = nil
                state.type = option.toType
                return .none
                
            case .updateButtonTapped:
                // If user  is developer, show alert
                guard state.admin.isUseAdminMenu else {
                    state.destination = .alert(.onNoPermissionAlert())
                    return .none
                }
                
                state.isLoading = true
                return .run { [state = state] send in
                    await send(
                        .addOrDeductAmountResponse(
                            Result {
                                try await userApiClient.addOrDeductAmount(
                                    for: state.type,
                                    admin: state.admin,
                                    user: state.memberSelect.selectedMembers[0],
                                    balance: state.amount.int
                                )
                            }
                        )
                    )
                }
                
            case .addOrDeductAmountResponse(.success):
                state.isLoading = false
                state.amount = ""
                state.destination = .alert(.onUpdateSuccessful())
                return .none
                
            case .addOrDeductAmountResponse(.failure(let error)):
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

// MARK: Confirmation Dialog
extension ConfirmationDialogState where Action == AddOrDeductAmount.Destination.ConfirmationDialog {
    static let selectType = ConfirmationDialogState {
        TextState("Select Type")
    } actions: {
        ButtonState(role: .cancel) {
            TextState(#localized("Cancel"))
        }
        ButtonState(action: .addTapped) {
            TextState(#localized("Add Amount"))
        }
        ButtonState(action: .deductTapped) {
            TextState(#localized("Deduct Amount"))
        }
    } message: {
        TextState(#localized("Select the type."))
    }
}

// MARK: Confirmation Dialog to Status Domain
// TODO: Could not extend AddOrDeductAmount.Destination.Action.ConfirmationDialog
// TODO: Not sure its a good idea to extend Equatable
extension Equatable where Self == AddOrDeductAmount.Destination.ConfirmationDialog {
    var toType: AddOrDeduct {
        switch self {
        case .addTapped: return .add
        case .deductTapped: return .deduct
        }
    }
}


// Analytics
extension AddOrDeductAmount {
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
        let parameter = Parameter(screenName: "add_or_deduct_view", actionName: eventType.actionName)
        analyticsClient.trackEvent(event: eventType.event, parameter: parameter)
    }
}
