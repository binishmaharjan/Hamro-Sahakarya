import Foundation
import ComposableArchitecture
import SharedModels
import SharedUIs

@Reducer
public struct Profile {
    @ObservableState @dynamicMemberLookup
    public struct State: Equatable {
        public init(user: User) {
            self.user = user
        }
        
        public subscript<T>(dynamicMember keyPath: KeyPath<User, T>) -> T {
            return user[keyPath: keyPath]
        }
        
        @Presents var destination: Destination.State?
        public var isLoading: Bool = false
        public var user: User
    }
    
    public enum Action: BindableAction, Equatable {
        public enum Delegate: Equatable {
            case signOutSuccessful
        }
        case destination(PresentationAction<Destination.Action>)
        case delegate(Delegate)
        case binding(BindingAction<State>)
        
        case onAppear
        case onMemberMenuTapped(Menu.Member)
        case onAdminMenuTapped(Menu.Admin)
        case onOtherMenuTapped(Menu.Other)
        case onSignOutButtonTapped
        case signOutUser
        case signOutResponse(TaskResult<VoidSuccess>)
    }
    
    public init() { }
    
    @Dependency(\.userApiClient) private var userApiClient
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                return .none

            case .onMemberMenuTapped(.changePicture):
                return .none
                
            case .onMemberMenuTapped(.changePassword):
                state.destination = .changePassword(.init())
                return .none
                
            case .onMemberMenuTapped(.members):
                state.destination = .membersList(.init())
                return .none
                
            case .onAdminMenuTapped(.expenseAndExtra):
                return .none
                
            case .onAdminMenuTapped(.monthlyFee):
                return .none
                
            case .onAdminMenuTapped(.loanMember):
                return .none
                
            case .onAdminMenuTapped(.loanReturned):
                return .none
                
            case .onAdminMenuTapped(.addOrDeduct):
                return .none
                
            case .onAdminMenuTapped(.changeStatus):
                return .none
                
            case .onAdminMenuTapped(.removeMember):
                return .none
                
            case .onAdminMenuTapped(.updateNotice):
                return .none
                
            case .onOtherMenuTapped(.termsAndCondition):
                return .none
                
            case .onSignOutButtonTapped:
                return .send(.signOutUser)
                
            case .signOutUser:
                state.isLoading = true
                return .run { send in
                    await send(
                        .signOutResponse(
                            TaskResult { try await userApiClient.signOut() }
                        )
                    )
                }
                
            case .signOutResponse(.success):
                state.isLoading = false
                return .send(.delegate(.signOutSuccessful))
                
            case .signOutResponse(.failure(let error)):
                state.isLoading = false
                state.destination = .alert(.signOutFailed(error))
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
extension Profile {
    @Reducer
    public struct Destination {
        @ObservableState
        public enum State: Equatable {
            case alert(AlertState<Action.Alert>)
            case membersList(MembersList.State)
            case changePassword(ChangePassword.State)
        }
        
        public enum Action: Equatable {
            public enum Alert: Equatable {}
            
            case alert(Alert)
            case membersList(MembersList.Action)
            case changePassword(ChangePassword.Action)
        }
        
        public init() { }
        
        public var body: some ReducerOf<Self> {
            Scope(state: \.membersList, action: \.membersList) {
                MembersList()
            }
            Scope(state: \.changePassword, action: \.changePassword) {
                ChangePassword()
            }
        }
    }
}

// MARK: AlertState
extension AlertState where Action == Profile.Destination.Action.Alert {
    static func signOutFailed(_ error: Error) -> AlertState {
        AlertState {
            TextState(#localized("Error"))
        } actions: {
            ButtonState { TextState(#localized("Ok")) }
        } message: {
            TextState(error.localizedDescription)
        }
    }
}
