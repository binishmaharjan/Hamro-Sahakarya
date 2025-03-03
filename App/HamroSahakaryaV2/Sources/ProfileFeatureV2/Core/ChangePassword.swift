import Foundation
import ComposableArchitecture
import SharedModels
import SharedUIs
import SwiftHelpers
import AnalyticsClient

@Reducer
public struct ChangePassword {
    @Reducer(state: .equatable)
    public enum Destination {
        case alert(AlertState<Alert>)
        
        public enum Alert: Equatable {
            case signOutButtonTapped
        }
    }
    
    @ObservableState
    public struct State: Equatable {
        public init(user: User) {
            self.user = user
        }
        
        @Presents var destination: Destination.State?
        var user: User
        var password: Password = ""
        var confirmPassword: Password = ""
        var isLoading: Bool = false
        
        var isValidInput: Bool {
            let isPasswordValid = password.count > 5
            let isConfirmPasswordValid = confirmPassword.count > 5
            return isPasswordValid && isConfirmPasswordValid
        }
    }
    
    public enum Action: BindableAction {
        @CasePathable
        public enum Delegate: Equatable {
            case signOutSuccessful
        }
        
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        case delegate(Delegate)
        
        case onAppear
        case changePasswordTapped
        case passwordDoesNotMatch
        case changePasswordResponse(Result<Void, Error>)
        case signOutUser
        case signOutResponse(Result<Void, Error>)
    }
    
    public init() { }
    
    @Dependency(\.userApiClient) private var userApiClient
    @Dependency(\.analyticsClient) private var analyticsClient
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                handleTrackingEvent(eventType: .screenView)
                return .none
                
            case .changePasswordTapped:
                guard state.password == state.confirmPassword else {
                    return .send(.passwordDoesNotMatch)
                }
                
                state.isLoading = true
                
                return .run { [user = state.user, password = state.password] send in
                    await send(
                        .changePasswordResponse(
                            Result {
                                return try await userApiClient.changePassword(
                                    for: user,
                                    newPassword: password
                                )
                            }
                        )
                    )
                }
                
            case .passwordDoesNotMatch:
                state.destination = .alert(.passwordDoesNotMatch())
                return .none
                
            case .changePasswordResponse(.success):
                state.isLoading = false
                state.destination = .alert(.changePasswordSuccess())
                return .none
                
            case .changePasswordResponse(.failure(let error)):
                state.isLoading = false
                state.destination = .alert(.onError(error))
                return .none
                
            case .destination(.presented(.alert(.signOutButtonTapped))):
                return .send(.signOutUser)
                
            case .signOutUser:
                state.isLoading = true
                
                return .run { send in
                    await send(
                        .signOutResponse(
                            Result {
                                return try await userApiClient.signOut()
                            }
                        )
                    )
                }
                
            case .signOutResponse(.success):
                state.isLoading = false
                return .send(.delegate(.signOutSuccessful))
                
            case .signOutResponse(.failure(let error)):
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

// MARK: AlertState
extension AlertState where Action == ChangePassword.Destination.Alert {
    static func passwordDoesNotMatch() -> AlertState {
        AlertState {
            TextState(#localized("Error"))
        } actions: {
            ButtonState { TextState(#localized("Ok")) }
        } message: {
            TextState("Password doesn't match")
        }
    }
    
    static func changePasswordSuccess() -> AlertState {
        AlertState {
            TextState(#localized("Change Password Successful"))
        } actions: {
            ButtonState(action: .signOutButtonTapped) {
                TextState(#localized("Sign Out"))
            }
        } message: {
            TextState(#localized("User will sign out.Please sign in again with new password"))
        }
    }
}


// Analytics
extension ChangePassword {
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
        let parameter = Parameter(screenName: "change_password_view", actionName: eventType.actionName)
        analyticsClient.trackEvent(event: eventType.event, parameter: parameter)
    }
}
