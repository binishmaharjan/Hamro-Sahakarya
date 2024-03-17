import Foundation
import ComposableArchitecture
import SharedModels
import SharedUIs
import UserApiClient
import SwiftHelpers

@Reducer
public struct ForgotPassword {
    @Reducer(state: .equatable)
    public enum Destination {
        case alert(AlertState<Alert>)
        
        public enum Alert: Equatable { }
    }
    
    @ObservableState
    public struct State: Equatable {
        public enum Field: Equatable {
            case email
        }
        
        public init() {}
        
        @Presents var destination: Destination.State?
        var email: String = ""
        var focusedField: Field? = .email
        var isLoading = false
        
        var isValidInput: Bool {
            email.contains("@") && email.contains(".")
        }
    }
    
    public enum Action: BindableAction {
        case destination(PresentationAction<Destination.Action>)
        case binding(BindingAction<State>)
        
        case forgotPasswordButtonTapped
        case closeButtonTapped
        case sendPasswordResetResponse(Result<Void, Error>)
    }
    
    public init(){ }
    
    @Dependency(\.dismiss) private var dismiss
    @Dependency(\.userApiClient) private var userApiClient
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce<State, Action> { state, action in
            switch action {
            case .forgotPasswordButtonTapped:
                state.isLoading = true
                return .run { [email = state.email] send in
                    await send(
                        .sendPasswordResetResponse(
                            Result {
                                return try await userApiClient.sendPasswordReset(email)
                            }
                        )
                    )
                }
                
            case .closeButtonTapped:
                return .run { _ in
                    await dismiss()
                }
                
            case .sendPasswordResetResponse(.success):
                state.isLoading = false
                state.destination = .alert(.sendPasswordResetSuccess)
                return .none
                
            case .sendPasswordResetResponse(.failure(let error)):
                state.isLoading = false
                state.destination = .alert(.onError(error))
                return .none
                
            case .binding, .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

// MARK: Alerts
extension AlertState where Action == ForgotPassword.Destination.Alert {
    static let sendPasswordResetSuccess = AlertState {
        TextState(#localized("Email Sent"))
    } actions: {
        ButtonState { TextState(#localized("Ok")) }
    } message: {
        TextState(#localized("Please check your email and follow the instructions sent to that email."))
    }
}
