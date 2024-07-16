import Foundation
import ComposableArchitecture
import UserAuthClient
import UserSessionClient
import SharedUIs
import SharedModels
import AnalyticsClient

@Reducer
public struct SignIn {
    @Reducer(state: .equatable)
    public enum Destination {
        case alert(AlertState<Alert>)
        case forgotPassword(ForgotPassword)
        case createUser(CreateUser)
        case adminPasswordInput(AdminPasswordInput)
        
        public enum Alert: Equatable { }
    }
    
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
        
        case onAppear
        case forgotPasswordButtonTapped
        case isSecureButtonTapped
        case viewTappedTwice
        case isAdminPasswordVerified(Bool)
        case signInButtonTapped
        case signInResponse(Result<User, Error>)
    }
    
    public init() {}
    
    @Dependency(\.userApiClient) private var userApiClient
    @Dependency(\.userSessionClient) private var userSessionClient
    @Dependency(\.continuousClock) private var clock
    @Dependency(\.analyticsClient) private var analyticsClient
    
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
                
            case .onAppear:
                handleTrackingEvent(eventType: .screenView)
                return .none
                
            case .signInButtonTapped:
                state.isLoading = true
                
                return .run { [email = state.email, password = state.password] send in
                    await send(
                        .signInResponse(
                            Result {
                                return try await userApiClient.signIn(withEmail: email, password: password)
                            }
                        )
                    )
                }
                
            case .forgotPasswordButtonTapped:
                state.destination = .forgotPassword(.init())
                return .none
                
            case .viewTappedTwice:
                state.destination = .adminPasswordInput(.init())
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
                userSessionClient.save(user)
                return .send(.delegate(.authenticationSuccessful(user)))
                
            case .signInResponse(.failure(let error)):
                state.isLoading = false
                state.destination = .alert(.onError(error))
                return .none
                
            case .binding, .destination, .delegate:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

// MARK: Admin Password Verification
extension SignIn {
    private func isVerified(_ password: Password) -> Bool {
        password == "admin"
    }
}

// MARK: AlertState
extension AlertState where Action == SignIn.Destination.Alert {
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

// Analytics
extension SignIn {
    enum EventType {
        case screenView
        
        var event: Event {
            switch self {
            case .screenView:
                return .screenView
            }
        }
        
        var actionName: String {
            switch self {
            case .screenView: return ""
            }
        }
    }
    
    private func handleTrackingEvent(eventType: EventType) {
        let parameter = Parameter(screenName: "sign_in_view", actionName: eventType.actionName)
        analyticsClient.trackEvent(event: eventType.event, parameter: parameter)
    }
}
