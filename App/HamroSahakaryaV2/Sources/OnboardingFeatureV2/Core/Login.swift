import Foundation
import ComposableArchitecture

@Reducer
public struct Login {
    public struct State: Equatable {
        public enum Field: Equatable {
            case email
            case password
        }
        
        public init() {}
        
        @BindingState var email: String = ""
        @BindingState var password: String = ""
        @BindingState var focusedField: Field? = .email
    }
    
    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        
        case loginButtonTapped
        case forgotPasswordButtonTapped
    }
    
    public init() {}
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce<State, Action> { state, action in
            switch action {
            case .loginButtonTapped:
                print("Login Button Tapped")
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
extension Login {
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
