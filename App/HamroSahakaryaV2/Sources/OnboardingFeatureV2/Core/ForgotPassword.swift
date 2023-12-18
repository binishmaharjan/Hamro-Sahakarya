import Foundation
import ComposableArchitecture

@Reducer
public struct ForgotPassword {
    public struct State: Equatable {
        public enum Field: Equatable {
            case email
            case password
        }
        
        public init() {}
        
        @BindingState var email: String = ""
        @BindingState var focusedField: Field? = .email
        
        var isValidInput: Bool {
            email.contains("@") && email.contains(".")
        }
    }
    
    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        
        case forgotPasswordButtonTapped
        case closeButtonTapped
    }
    
    public init(){ }
    
    @Dependency(\.dismiss) private var dismiss
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce<State, Action> { state, action in
            switch action {
            case .forgotPasswordButtonTapped:
                print("Forgot Button Tapped")
                return .none
                
            case .closeButtonTapped:
                return .run { _ in
                    await dismiss()
                }
                
            case .binding:
                return .none
            }
        }
    }
}


