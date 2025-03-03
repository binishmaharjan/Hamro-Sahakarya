import Foundation
import ComposableArchitecture
import SharedUIs
import SharedModels
import UserApiClient
import SwiftHelpers
import AnalyticsClient

@Reducer
public struct ExtraIncomeAndExpenses {
    @Reducer(state: .equatable)
    public enum Destination {
        case confirmationDialog(ConfirmationDialogState<ConfirmationDialog>)
        case alert(AlertState<Alert>)
        
        public enum Alert: Equatable { }
        public enum ConfirmationDialog: Equatable {
            case extraTapped
            case expensesTapped
        }
    }
    
    @ObservableState
    public struct State: Equatable {
        public init(admin: User) {
            self.admin = admin
        }
        
        @Presents var destination: Destination.State?
        var admin: User
        var type: ExtraOrExpenses = .extra
        var amount: String = ""
        var reason: String = ""
        var isLoading: Bool = false
        
        var isValidInput: Bool {
            let isAmountValid = amount.int > 0
            let isReasonValid = reason.count > 1
            
            return isAmountValid && isReasonValid
        }
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        
        case onAppear
        case typeFieldTapped
        case updateButtonTapped
        case addExtraOrExpensesResponse(Result<Void, Error>)
    }
    
    public init() { }
    
    @Dependency(\.userApiClient) private var userApiClient
    @Dependency(\.analyticsClient) private var analyticsClient
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce<State, Action> { state, action in
            switch action {
            case .destination(.presented(.confirmationDialog(let option))):
                state.destination = nil
                state.type = option.toType
                return .none
                
            case .onAppear:
                handleTrackingEvent(eventType: .screenView)
                return .none
                
            case .typeFieldTapped:
                state.destination = .confirmationDialog(.selectType)
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
                        .addExtraOrExpensesResponse(
                            Result {
                                return try await userApiClient.addExtraAndExpenses(
                                    for: state.type,
                                    admin: state.admin,
                                    balance: state.amount.int,
                                    reason: state.reason
                                )
                            }
                        )
                    )
                }
                
            case .addExtraOrExpensesResponse(.success):
                state.isLoading = false
                state.amount = ""
                state.reason = ""
                state.destination = .alert(.onUpdateSuccessful())
                return .none
                
            case .addExtraOrExpensesResponse(.failure(let error)):
                state.isLoading = false
                state.destination = .alert(.onError(error))
                return .none
                
            case .binding, .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

// MARK: Confirmation Dialog
extension ConfirmationDialogState where Action == ExtraIncomeAndExpenses.Destination.ConfirmationDialog {
    static let selectType = ConfirmationDialogState {
        TextState("Select Type")
    } actions: {
        ButtonState(role: .cancel) {
            TextState(#localized("Cancel"))
        }
        ButtonState(action: .extraTapped) {
            TextState(#localized("Extra"))
        }
        ButtonState(action: .expensesTapped) {
            TextState(#localized("Expenses"))
        }
    } message: {
        TextState(#localized("Select the type."))
    }
}

// MARK: Confirmation Dialog to Status Domain
// TODO: Could not extend CreateUser.Destination.Action.ConfirmationDialog
// TODO: Not sure its a good idea to extend Equatable
extension Equatable where Self == ExtraIncomeAndExpenses.Destination.ConfirmationDialog {
    var toType: ExtraOrExpenses {
        switch self {
        case .extraTapped: return .extra
        case .expensesTapped: return .expenses
        }
    }
}

// Analytics
extension ExtraIncomeAndExpenses {
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
        let parameter = Parameter(screenName: "extra_and_expenses_view", actionName: eventType.actionName)
        analyticsClient.trackEvent(event: eventType.event, parameter: parameter)
    }
}
