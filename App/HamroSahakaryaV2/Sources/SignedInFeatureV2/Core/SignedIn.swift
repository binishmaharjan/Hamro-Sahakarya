import Foundation
import ComposableArchitecture
import SharedModels
import UserSessionClient
import HomeFeatureV2
import LogsFeatureV2
import ProfileFeatureV2

@Reducer
public struct SignedIn {
    @ObservableState
    public struct State: Equatable {
        public init(user: User) {
            self.user = user
            self.home = Home.State(user: user)
            self.logs = Logs.State()
            self.profile = Profile.State(user: user)
            self.selectedTab = .home
        }
        
        public var user: User
        public var home: Home.State
        public var logs: Logs.State
        public var profile: Profile.State
        public var selectedTab: Tab
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case home(Home.Action)
        case logs(Logs.Action)
        case profile(Profile.Action)
        case tabSelected(Tab)
    }
    
    public init() { }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce<State, Action> { state, action in
            switch action {
            case .tabSelected(let tab):
                state.selectedTab = tab
                return tab == .logs ? .send(.logs(.tabBarTapped)) : .none 
                
            case .binding, .home, .logs, .profile:
                return .none
            }
        }
        
        Scope(state: \.home, action: \.home) {
            Home()
        }
        
        Scope(state: \.logs, action: \.logs) {
            Logs()
        }
        
        Scope(state: \.profile, action: \.profile) {
            Profile()
        }
    }
}
