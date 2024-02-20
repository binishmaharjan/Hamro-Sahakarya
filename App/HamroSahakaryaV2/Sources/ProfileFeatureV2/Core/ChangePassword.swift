import Foundation
import ComposableArchitecture
import SharedModels
import SharedUIs
import SwiftHelpers

@Reducer
public struct ChangePassword {
    @ObservableState
    public struct State: Equatable {
        public enum Field: Equatable {
            case password
            case confirmPassword
        }
        public init(user: User) {
            self.user = user
        }
        
        @Presents var destination: Destination.State?
        var user: User
        var password: Password = ""
        var confirmPassword: Password = ""
        var focusedField: Field? = .password
        var isLoading: Bool = false
        
        var isValidInput: Bool {
            let isPasswordValid = password.count > 5
            let isConfirmPasswordValid = confirmPassword.count > 5
            return isPasswordValid && isConfirmPasswordValid
        }
    }
    
    public enum Action: BindableAction, Equatable {
        public enum Delegate: Equatable {
            case signOutSuccessful
        }
        
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        case delegate(Delegate)
        
        case changePasswordTapped
        case passwordDoesntMatch
        case changePasswordResponse(TaskResult<VoidSuccess>)
        case signOutUser
        case signOutResponse(TaskResult<VoidSuccess>)
    }
    
    public init() { }
    
    @Dependency(\.userApiClient) private var userApiClient
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce<State, Action> { state, action in
            switch action {
            case .changePasswordTapped:
                guard state.password == state.confirmPassword else {
                    return .send(.passwordDoesntMatch)
                }
                
                state.isLoading = true
                
                return .run { [user = state.user, password = state.password] send in
                    await send(
                        .changePasswordResponse(
                            TaskResult {
                                return try await userApiClient.changePassword(user, password)
                            }
                        )
                    )
                }
                
            case .passwordDoesntMatch:
                state.destination = .alert(.passwordDoesntMatch())
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
                            TaskResult {
                                return try await userApiClient.signOut()
                            }
                        )
                    )
                }
                
            case .signOutResponse(.success):
                state.isLoading = false
                return .send(.delegate(.signOutSuccessful))
                
            case .signOutResponse(.failure(let error)):
                state.isLoading = true
                state.destination = .alert(.onError(error))
                return .none
                
            case .destination(.presented(.alert(.signOutButtonTapped))):
                state.isLoading = true
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
extension ChangePassword {
    @Reducer
    public struct Destination {
        @ObservableState
        public enum State: Equatable {
            case alert(AlertState<Action.Alert>)
        }
        
        public enum Action: Equatable {
            public enum Alert: Equatable {
                case signOutButtonTapped
            }
            
            case alert(Alert)
        }
        
        public var body: some Reducer<State, Action> {
            Reduce<State, Action> { state, action in
                return .none
            }
        }
    }
}

// MARK: AlertState
extension AlertState where Action == ChangePassword.Destination.Action.Alert {
    static func passwordDoesntMatch() -> AlertState {
        AlertState {
            TextState(#localized("Error"))
        } actions: {
            ButtonState { TextState(#localized("Ok")) }
        } message: {
            TextState("Password doesn`t match")
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
