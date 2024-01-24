import Foundation
import ComposableArchitecture
import SharedModels
import UserSession
import HomeFeatureV2
import LogsFeatureV2
import ProfileFeatureV2

@Reducer
public struct SignedIn {
    public struct State: Equatable {
        public init(userSession: UserSession) {
            self.userSession = userSession
            self.home = Home.State()
            self.logs = Logs.State()
            self.profile = Profile.State()
            self.selectedTab = .logs
        }
        
        public var userSession: UserSession
        public var home: Home.State
        public var logs: Logs.State
        public var profile: Profile.State
        @BindingState public var selectedTab: Tab
    }
    
    public enum Action: BindableAction, Equatable {
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
                return .none
                
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