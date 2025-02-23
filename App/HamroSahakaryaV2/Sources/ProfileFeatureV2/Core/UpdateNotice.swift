import Foundation
import ComposableArchitecture
import SharedModels
import UserApiClient
import AnalyticsClient

@Reducer
public struct UpdateNotice {
    @Reducer(state: .equatable)
    public enum Destination {
        case alert(AlertState<Alert>)
        
        public enum Alert: Equatable { }
    }
    
    @ObservableState
    public struct State: Equatable {
        public init(admin: User) {
            self.admin = admin
        }
        
        @Presents var destination: Destination.State?
        var admin: User
        var notice: String = ""
        var isLoading: Bool = false
        var isValidInput: Bool {
            return notice.count > 0
        }
    }
    
    public enum Action: BindableAction {
        case destination(PresentationAction<Destination.Action>)
        case binding(BindingAction<State>)
        
        case onAppear
        case updateButtonTapped
        case updateNoticeResponse(Result<Void, Error>)
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

            case .updateButtonTapped:
                // If user  is developer, show alert
                guard state.admin.isUseAdminMenu else {
                    state.destination = .alert(.onNoPermissionAlert())
                    return .none
                }
                
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

// Analytics
extension UpdateNotice {
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
        let parameter = Parameter(screenName: "update_notice_view", actionName: eventType.actionName)
        analyticsClient.trackEvent(event: eventType.event, parameter: parameter)
    }
}
