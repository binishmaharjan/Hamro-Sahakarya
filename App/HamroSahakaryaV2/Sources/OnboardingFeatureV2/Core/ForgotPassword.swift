import Foundation
import ComposableArchitecture
import SharedModels
import SharedUIs

@Reducer
public struct ForgotPassword {
    public struct State: Equatable {
        public enum Field: Equatable {
            case email
            case password
        }
        
        public init() {}
        
        @PresentationState var destination: Destination.State?
        @BindingState var email: String = ""
        @BindingState var focusedField: Field? = .email
        
        var isValidInput: Bool {
            email.contains("@") && email.contains(".")
        }
    }
    
    public enum Action: BindableAction, Equatable {
        case destination(PresentationAction<Destination.Action>)
        case binding(BindingAction<State>)
        
        case forgotPasswordButtonTapped
        case closeButtonTapped
        case sendPasswordReset(TaskResult<VoidSuccess>)
    }
    
    public init(){ }
    
    @Dependency(\.dismiss) private var dismiss
    @Dependency(\.authClient) private var authClient
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce<State, Action> { state, action in
            switch action {
            case .forgotPasswordButtonTapped:
                return .run { [email = state.email] send in
                    await send(
                        .sendPasswordReset(
                            TaskResult {
                                return try await authClient.sendPasswordReset(email)
                            }
                        )
                    )
                }
                
            case .closeButtonTapped:
                return .run { _ in
                    await dismiss()
                }
                
            case .sendPasswordReset(.success):
                state.destination = .alert(.sendPasswordResetSuccess)
                return .none
                
            case .sendPasswordReset(.failure(let error)):
                state.destination = .alert(.sendPasswordResetFailed(error))
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
extension ForgotPassword {
    @Reducer
    public struct Destination: Equatable {
        public enum State: Equatable {
            case alert(AlertState<Action.Alert>)
        }
        
        public enum Action: Equatable {
            public enum Alert: Equatable {
            }
            case alert(Alert)
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

// MARK: Alerts
extension AlertState where Action == ForgotPassword.Destination.Action.Alert {
    static let sendPasswordResetSuccess = AlertState {
        TextState(#localized("Email Sent"))
    } actions: {
        ButtonState { TextState(#localized("Ok")) }
    } message: {
        TextState(#localized("Please check your email and follow the instructions sent to that email."))
    }
    
    static func sendPasswordResetFailed(_ error: Error) -> AlertState {
        AlertState {
            TextState(#localized("Error"))
        } actions: {
            ButtonState { TextState(#localized("Cancel")) }
        } message: {
            TextState(error.localizedDescription)
        }
    }
}
