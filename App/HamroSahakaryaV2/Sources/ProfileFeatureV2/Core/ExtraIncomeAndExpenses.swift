import Foundation
import ComposableArchitecture
import SharedUIs
import SharedModels
import UserApiClient
import SwiftHelpers

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
        var user: User
        var type: ExtraOrExpenses = .extra
        var amount: String = ""
        var reason: String = ""
        var focusedField: Field? = .amount
        var isLoading: Bool = false
        
        var isValidInput: Bool {
            let isAmountValid = amount.int > 0
            let isReasonValid = reason.count > 1
            
            return isAmountValid && isReasonValid
        }
    }
    
    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        
        case typeFieldTapped
        case updateButtonTapped
        case addExtraOrExpensesResponse(TaskResult<VoidSuccess>)
    }
    
    public init() { }
    
    @Dependency(\.userApiClient) private var userApiClient
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce<State, Action> { state, action in
            switch action {
            case .destination(.presented(.confirmationDialog(.presented(let option)))):
                state.destination = nil
                state.type = option.toType
                return .none
                
            case .typeFieldTapped:
                state.destination = .confirmationDialog(.selectType)
                return .none
                
            case .updateButtonTapped:
                state.isLoading = true
                return .run { [state = state] send in
                    await send(
                        .addExtraOrExpensesResponse(
                            TaskResult {
                                return try await userApiClient.addExtraAndExpenses(
                                    state.user,
                                    state.type,
                                    state.amount.int,
                                    state.reason
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
        .ifLet(\.$destination, action: \.destination) {
            Destination()
        }
    }
}

// MARK: Confirmation Dialog
extension ConfirmationDialogState where Action == ExtraIncomeAndExpenses.Destination.Action.ConfirmationDialog {
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
