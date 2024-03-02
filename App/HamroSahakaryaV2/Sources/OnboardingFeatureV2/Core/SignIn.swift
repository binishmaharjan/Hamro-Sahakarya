import Foundation
import ComposableArchitecture
import UserAuthClient
import SharedUIs
import SharedModels

@Reducer
public struct SignIn {
    @ObservableState
    public struct State: Equatable {
        public enum Field: Equatable {
            case email
            case password
        }
        
        public init() {}
        
        @Presents var destination: Destination.State?
        var email: Email = ""
        var password: Password = ""
        var focusedField: Field? = .email
        var isSecure: Bool = true
        var isLoading: Bool = false
        
        var isValidInput: Bool {
            let isEmailValid = email.contains("@") && email.contains(".")
            let isPasswordValid = password.count > 5
            return isEmailValid && isPasswordValid
        }
    }
    
    public enum Action: BindableAction {
        @CasePathable
        public enum Delegate: Equatable {
            case authenticationSuccessful(User)
        }
        
        case destination(PresentationAction<Destination.Action>)
        case binding(BindingAction<State>)
        case delegate(Delegate)
        
        case forgotPasswordButtonTapped
        case isSecureButtonTapped
        case viewTappedTwice
        case isAdminPasswordVerified(Bool)
        case signInButtonTapped
        case signInResponse(Result<User, Error>)
    }
    
    public init() {}
    
    @Dependency(\.userApiClient) private var userApiClient
    @Dependency(\.continuousClock) private var clock
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce<State, Action> { state, action in
            switch action {
            case .destination(.presented(.adminPasswordInput(.delegate(.verifyAdminPassword(let adminPassword))))):
                state.destination = nil
            
                return .run { send in
                    // Wait for dismiss animation to finish
                    try await clock.sleep(for: .seconds(0.3))
                    await send(.isAdminPasswordVerified(isVerified(adminPassword)))
                }
                
            case .destination(.presented(.createUser(.delegate(.createAccountSuccessful(let user))))):
                return .send(.delegate(.authenticationSuccessful(user)))
                
            case .signInButtonTapped:
                state.isLoading = true
                
                return .run { [email = state.email, password = state.password] send in
                    await send(
                        .signInResponse(
                            Result {
                                return try await userApiClient.signIn(email, password)
                            }
                        )
                    )
                }
                
            case .forgotPasswordButtonTapped:
                state.destination = .forgotPassword(.init())
                return .none
                
            case .viewTappedTwice:
                state.destination =  .adminPasswordInput(.init())
                return .none
                
            case .isSecureButtonTapped:
                state.isSecure.toggle()
                return .none
                
            case .isAdminPasswordVerified(let isSuccess):
                if isSuccess {
                    state.destination =  .createUser(.init())
                } else {
                    state.destination =  .alert(.adminPasswordVerificationFailed())
                }
                
                return .none
                
            case .signInResponse(.success(let user)):
                state.isLoading = false
                return .send(.delegate(.authenticationSuccessful(user)))
                
            case .signInResponse(.failure(let error)):
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
extension SignIn {
    @Reducer
    public struct Destination {
        @ObservableState
        public enum State: Equatable {
            case alert(AlertState<Action.Alert>)
            case forgotPassword(ForgotPassword.State)
            case createUser(CreateUser.State)
            case adminPasswordInput(AdminPasswordInput.State)
        }
        
        public enum Action {
            public enum Alert: Equatable { }
            
            case alert(Alert)
            case forgotPassword(ForgotPassword.Action)
            case createUser(CreateUser.Action)
            case adminPasswordInput(AdminPasswordInput.Action)
        }
        
        public var body: some Reducer<State, Action> {
            Scope(state: \.forgotPassword, action: \.forgotPassword) {
                ForgotPassword()
            }
            
            Scope(state: \.createUser, action: \.createUser) {
                CreateUser()
            }
            
            Scope(state: \.adminPasswordInput, action: \.adminPasswordInput) {
                AdminPasswordInput()
            }
        }
    }
}

// MARK: Admin Password Verification
extension SignIn {
    private func isVerified(_ password: Password) -> Bool {
        password == "admin"
    }
}

// MARK: AlertState
extension AlertState where Action == SignIn.Destination.Action.Alert {
    static func adminPasswordVerificationFailed() -> AlertState {
        AlertState {
            TextState(#localized("Sorry"))
        } actions: {
            ButtonState { TextState(#localized("Cancel")) }
        } message: {
            TextState("Couldn't verify admin password")
        }
    }
}
