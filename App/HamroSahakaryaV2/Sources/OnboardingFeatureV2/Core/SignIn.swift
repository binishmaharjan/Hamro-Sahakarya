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
                print("Forgot Password Button Tapped")
                return .none
                
            case .binding:
                return .none
            }
        }
    }
}

// MARK: Destination
extension SignIn {
    @Reducer
    public struct Destination {
        public struct State: Equatable {
            
        }
        
        public struct Action: Equatable {
            
        }
        
        public var body: some Reducer<State, Action> {
            Reduce<State, Action> { state, action in
                return .none
            }
        }
    }
}
