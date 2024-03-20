import Foundation
import ComposableArchitecture
import SharedModels
import UserApiClient

@Reducer
public struct UpdateNotice {
    @Reducer(state: .equatable)
    public enum Destination {
        case alert(AlertState<Alert>)
        
        public enum Alert: Equatable { }
    }
    
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
                                    by: state.admin,
                                    message: state.notice
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
        .ifLet(\.$destination, action: \.destination)
    }
}
