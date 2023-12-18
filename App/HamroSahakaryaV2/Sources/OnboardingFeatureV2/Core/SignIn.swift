import Foundation
import ComposableArchitecture

@Reducer
public struct SignIn {
    public struct State: Equatable {
        public enum Field: Equatable {
            case email
            case password
        }
        
        public init() {}
        
        @PresentationState var destination: Destination.State?
        @BindingState var email: String = ""
        @BindingState var password: String = ""
        @BindingState var focusedField: Field? = .email
        
        var isValidInput: Bool {
            let isEmailValid = email.contains("@") && email.contains(".")
            let isPasswordValid = password.count > 5
            return isEmailValid && isPasswordValid
        }
    }
    
    public enum Action: BindableAction, Equatable {
        case destination(PresentationAction<Destination.Action>)
        case binding(BindingAction<State>)
        
        case signInButtonTapped
        case forgotPasswordButtonTapped
    }
    
    public init() {}
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce<State, Action> { state, action in
            switch action {
            case .signInButtonTapped:
                print("signIn Button Tapped")
                return .none
                
            case .forgotPasswordButtonTapped:
                state.destination = .forgotPassword(.init())
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
extension SignIn {
    @Reducer
    public struct Destination {
        public enum State: Equatable {
            case forgotPassword(ForgotPassword.State)
        }
        
        public enum Action: Equatable {
            case forgotPassword(ForgotPassword.Action)
        }
        
        public var body: some Reducer<State, Action> {
            Scope(state: \.forgotPassword, action: \.forgotPassword) {
                ForgotPassword()
            }
        }
    }
}
