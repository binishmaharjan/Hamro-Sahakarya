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
        @BindingState var colorHex: String = ""
        @BindingState var initialAmount: String = "0"
    }
    
    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        
        case createUserButtonTapped
        case memberFieldTapped
    }
    
    public init(){ }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce<State, Action> { state, action in
            switch action {
            case .destination(.presented(.confirmationDialog(.presented(let option)))):
                state.destination = nil
                state.status = option.toStatus
                return .none
                
            case .createUserButtonTapped:
                return .none
                
            case .memberFieldTapped:
                state.destination = .confirmationDialog(.selectStatus)
                return .none
                
            case .binding, .destination:
                return .none
            }
        }
    }
}

// MARK: Destination
extension CreateUser {
    @Reducer
    public struct Destination {
        public enum State: Equatable {
            case confirmationDialog(ConfirmationDialogState<Action.ConfirmationDialog>)
        }
        
        public enum Action: Equatable {
            public enum ConfirmationDialog: Equatable {
                case memberTapped
                case adminTapped
            }
            
            case confirmationDialog(PresentationAction<ConfirmationDialog>)
        }
        
        public init(){ }
        
        public var body: some
        ReducerOf<Self> {
            Reduce<State, Action> { state, action in
                return .none
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
