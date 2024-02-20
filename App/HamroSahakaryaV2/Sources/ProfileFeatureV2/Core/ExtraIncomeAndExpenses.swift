import Foundation
import ComposableArchitecture
import SharedUIs
import SharedModels
import UserApiClient

// TODO: Text Field binding is not working
@Reducer
public struct ExtraIncomeAndExpenses {
    @ObservableState
    public struct State: Equatable {
        public enum Field: Equatable {
            case amount
            case reason
        }
        public init(user: User) {
            self.user = user
        }
        
        @Presents var destination: Destination.State?
        public var user: User
        var type: ExtraOrExpenses = .extra
        var amount: String = "0"
        var reason: String = ""
        var focusedField: Field? = .amount
        var isLoading: Bool = false
        
        var isValidInput: Bool {
            let isAmountValid = Int(amount) ?? 0 > 0
            let isReasonValid = reason.count > 1
            
            return isAmountValid && isReasonValid
        }
    }
    
    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        
        case typeFieldTapped
        case updateButtonTapped
        case addExtraOrExpenses
        case addExtraOrExpensesResponse(TaskResult<VoidSuccess>)
    }
    
    public init() { }
    
    @Dependency(\.userApiClient) private var userApiClient
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .binding(\.amount):
                print(state.amount)
                return .none
                
            case .binding(\.reason):
                print(state.reason)
                return .none
                
            case .destination(.presented(.confirmationDialog(.presented(let option)))):
                state.destination = nil
                state.type = option.toType
                return .none
                
            case .typeFieldTapped:
                state.destination = .confirmationDialog(.selectedType)
                return .none
                
            case .updateButtonTapped:
                return .send(.addExtraOrExpenses)
                
            case .addExtraOrExpenses:
                state.isLoading = true
                return .run { [state = state] send in
                    await send(
                        .addExtraOrExpensesResponse(
                            TaskResult {
                                return try await userApiClient.addExtraAndExpenses(
                                    state.user,
                                    state.type,
                                    Int(state.amount) ?? 0,
                                    state.reason
                                )
                            }
                        )
                    )
                }
                
            case .addExtraOrExpensesResponse(.success):
                state.isLoading = false
                state.destination = .alert(.addExtraOrExpensesSuccess())
                return .none
                
            case .addExtraOrExpensesResponse(.failure(let error)):
                state.isLoading = false
                state.destination = .alert(.addExtraOrExpensesFailed(error))
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

// MARK: Confirmation Dialog
extension ConfirmationDialogState where Action == ExtraIncomeAndExpenses.Destination.Action.ConfirmationDialog {
    static let selectedType = ConfirmationDialogState {
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
extension Equatable where Self == ExtraIncomeAndExpenses.Destination.Action.ConfirmationDialog {
    var toType: ExtraOrExpenses {
        switch self {
        case .extraTapped: return .extra
        case .expensesTapped: return .expenses
        }
    }
}

// MARK: Destination
extension ExtraIncomeAndExpenses {
    @Reducer
    public struct Destination {
        @ObservableState
        public enum State: Equatable {
            case confirmationDialog(ConfirmationDialogState<Action.ConfirmationDialog>)
            case alert(AlertState<Action.Alert>)
        }
        
        public enum Action: Equatable {
            public enum Alert: Equatable { }
            public enum ConfirmationDialog: Equatable {
                case extraTapped
                case expensesTapped
            }
            
            case confirmationDialog(PresentationAction<ConfirmationDialog>)
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

// MARK: AlertState
extension AlertState where Action == ExtraIncomeAndExpenses.Destination.Action.Alert {
    static func addExtraOrExpensesFailed(_ error: Error) -> AlertState {
        AlertState {
            TextState(#localized("Error"))
        } actions: {
            ButtonState { TextState(#localized("Ok")) }
        } message: {
            TextState(error.localizedDescription)
        }
    }
    
    static func addExtraOrExpensesSuccess() -> AlertState {
        AlertState {
            TextState(#localized("Success"))
        } actions: {
            ButtonState { TextState(#localized("Ok")) }
        } message: {
            TextState(#localized("Update Successful"))
        }
    }
}
