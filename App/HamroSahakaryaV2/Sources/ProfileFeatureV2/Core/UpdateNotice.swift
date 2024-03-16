import Foundation
import ComposableArchitecture
import SharedModels
import UserApiClient

@Reducer
public struct UpdateNotice {
    @ObservableState
    public struct State: Equatable {
        public enum Field: Equatable {
            case notice
        }
        public init(admin: User) {
            self.admin = admin
        }
        
        @Presents var destination: Destination.State?
        var admin: User
        var notice: String = ""
        var isLoading: Bool = false
        var focusedField: Field? = .notice
        var isValidInput: Bool {
            return notice.count > 0
        }
    }
    
    public enum Action: BindableAction {
        case destination(PresentationAction<Destination.Action>)
        case binding(BindingAction<State>)
        
        case updateButtonTapped
        case updateNoticeResponse(Result<Void, Error>)
    }
    
    public init() { }
    
    @Dependency(\.userApiClient) private var userApiClient
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce<State, Action> { state, action in
            switch action {
            case .updateButtonTapped:
                state.isLoading = true
                return .run { [state = state] send in
                    await send(
                        .updateNoticeResponse(
                            Result {
                                try await userApiClient.updateNotice(
                                    state.admin,
                                    state.notice
                                )
                            }
                        )
                    )
                }
                
            case .updateNoticeResponse(.success):
                state.isLoading = false
                state.notice = ""
                state.destination = .alert(.onUpdateSuccessful())
                return .none
                
            case .updateNoticeResponse(.failure(let error)):
                state.isLoading = false
                state.destination = .alert(.onError(error))
                return .none
                
            case .destination, .binding:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination()
        }
    }
}

// MARK: Destination
extension UpdateNotice {
    @Reducer
    public struct Destination {
        public enum State: Equatable {
            case alert(AlertState<Action.Alert>)
        }
        
        public enum Action {
            public enum Alert: Equatable {}
            
            case alert(Alert)
        }
        
        public init() { }
        
        public var body: some ReducerOf<Self> {
            Reduce<State, Action> { state, action in
                return .none
            }
        }
    }
}
