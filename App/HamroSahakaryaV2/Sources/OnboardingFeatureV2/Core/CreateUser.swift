import Foundation
import ComposableArchitecture
import SharedModels

@Reducer
public struct CreateUser {
    public struct State: Equatable {
        
        public init() {}
        
        @PresentationState var destination: Destination.State?
        @BindingState var email: String = ""
        @BindingState var fullname: String = ""
        @BindingState var password: String = ""
        @BindingState var status: Status = .member
        @BindingState var colorHex: String = "#F77D8E"
        @BindingState var initialAmount: String = "0"
        
        var isLoading: Bool = false
        
        var isValidInput: Bool {
            let isEmailValid = email.contains("@") && email.contains(".")
            let isPasswordValid = password.count > 5
            let isFullNameValid = !fullname.isEmpty
            
            return isEmailValid && isPasswordValid && isFullNameValid
        }
    }
    
    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        
        case createUserButtonTapped
        case memberFieldTapped
        case colorPickerFieldTapped
        case createUserResponse(TaskResult<AccountId>)
    }
    
    public init(){ }
    
    @Dependency(\.authClient) private var authClient
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce<State, Action> { state, action in
            switch action {
            case .destination(.presented(.confirmationDialog(.presented(let option)))):
                state.destination = nil
                state.status = option.toStatus
                return .none
                
            case .destination(.presented(.colorPicker(.delegate(.colorSelected(let colorHex))))):
                state.colorHex = colorHex
                state.destination = nil
                return .none
                
            case .destination(.presented(.colorPicker(.delegate(.close)))):
                state.destination = nil
                return .none
                
            case .memberFieldTapped:
                state.destination = .confirmationDialog(.selectStatus)
                return .none
                
            case .colorPickerFieldTapped:
                state.destination = .colorPicker(.init())
                return .none
                
            case .createUserButtonTapped:
                state.isLoading = false
                return .none
                
            case .createUserResponse(.success(let accountId)):
                return .none
                
            case .createUserResponse(.failure(let error)):
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

// MARK: Destination
extension CreateUser {
    @Reducer
    public struct Destination {
        public enum State: Equatable {
            case confirmationDialog(ConfirmationDialogState<Action.ConfirmationDialog>)
            case colorPicker(ColorPicker.State)
        }
        
        public enum Action: Equatable {
            public enum ConfirmationDialog: Equatable {
                case memberTapped
                case adminTapped
            }
            
            case confirmationDialog(PresentationAction<ConfirmationDialog>)
            case colorPicker(ColorPicker.Action)
        }
        
        public init(){ }
        
        public var body: some ReducerOf<Self> {
            Scope(state: \.colorPicker, action: \.colorPicker) {
                ColorPicker()
            }
        }
    }
}

// MARK: Confirmation Dialog to Status Domain
// TODO: Could not extend CreateUser.Destination.Action.ConfirmationDialog
// TODO: Not sure its a good idea to extend Equatable
extension Equatable where Self == CreateUser.Destination.Action.ConfirmationDialog {
    var toStatus: Status {
        switch self {
        case .memberTapped: return .member
        case .adminTapped: return .admin
        }
    }
}


// MARK: Confirmation Dialog
extension ConfirmationDialogState where Action == CreateUser.Destination.Action.ConfirmationDialog {
    static let selectStatus = ConfirmationDialogState {
        TextState("Status Select")
    } actions: {
        ButtonState(role: .cancel) {
          TextState("Cancel")
        }
        ButtonState(action: .memberTapped) {
          TextState("Member")
        }
        ButtonState(action: .adminTapped) {
          TextState("Admin")
        }
    } message: {
        TextState("Select the member status.")
    }
}
