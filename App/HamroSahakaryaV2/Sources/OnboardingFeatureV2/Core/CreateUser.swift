import Foundation
import ComposableArchitecture
import SharedModels
import SharedUIs
import UserApiClient

@Reducer
public struct CreateUser {
    @ObservableState
    public struct State: Equatable {
        public init() {}
        
        @Presents var destination: Destination.State?
        var email: String = ""
        var fullname: String = ""
        var password: String = ""
        var status: Status = .member
        var colorHex: String = "#F77D8E"
        var initialAmount: String = "0"
        
        var isLoading: Bool = false
        
        var isValidInput: Bool {
            let isEmailValid = email.contains("@") && email.contains(".")
            let isPasswordValid = password.count > 5
            let isFullNameValid = !fullname.isEmpty
            
            return isEmailValid && isPasswordValid && isFullNameValid
        }
    }
    
    public enum Action: BindableAction, Equatable {
        public enum Delegate: Equatable {
            case createAccountSuccessful(User)
        }
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        case delegate(Delegate)
        
        case createUserButtonTapped
        case memberFieldTapped
        case colorPickerFieldTapped
        case createUserResponse(TaskResult<User>)
    }
    
    public init(){ }
    
    @Dependency(\.userApiClient) private var userApiClient
    
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
                state.isLoading = true
                let newUser = createNewUser(state: state)
                return .run { send in
                    await send(
                        .createUserResponse(
                            TaskResult {
                                return try await userApiClient.createUser(newUser)
                            }
                        )
                    )
                }
                
            case .createUserResponse(.success(let user)):
                state.isLoading = false
                return .send(.delegate(.createAccountSuccessful(user)))
                
            case .createUserResponse(.failure(let error)):
                state.isLoading = false
                state.destination = .alert(.onError(error))
                return .none
                
            case .binding, .destination, .delegate:
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
        @ObservableState
        public enum State: Equatable {
            case confirmationDialog(ConfirmationDialogState<Action.ConfirmationDialog>)
            case alert(AlertState<Action.Alert>)
            case colorPicker(ColorPicker.State)
        }
        
        public enum Action: Equatable {
            public enum Alert: Equatable { }
            public enum ConfirmationDialog: Equatable {
                case memberTapped
                case adminTapped
            }
            
            case confirmationDialog(PresentationAction<ConfirmationDialog>)
            case alert(Alert)
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

// MARK: New User
extension CreateUser {
    private func createNewUser(state: State) -> NewUser {
        return NewUser(
            username: state.fullname,
            email: state.email,
            status: state.status,
            colorHex: state.colorHex,
            dateCreated: Date.now.toString(for: .dateTime),
            keyword: state.password,
            initialAmount: Int(state.initialAmount) ?? 0
        )
    }
}


// MARK: Confirmation Dialog
extension ConfirmationDialogState where Action == CreateUser.Destination.Action.ConfirmationDialog {
    static let selectStatus = ConfirmationDialogState {
        TextState(#localized("Status Select"))
    } actions: {
        ButtonState(role: .cancel) {
          TextState(#localized("Cancel"))
        }
        ButtonState(action: .memberTapped) {
          TextState(#localized("Member"))
        }
        ButtonState(action: .adminTapped) {
          TextState(#localized("Admin"))
        }
    } message: {
        TextState(#localized("Select the member status."))
    }
}
