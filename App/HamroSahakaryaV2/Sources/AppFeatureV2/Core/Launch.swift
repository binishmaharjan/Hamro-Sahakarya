import Foundation
import ComposableArchitecture
import UserDefaultsClient
import SharedModels

@Reducer
public struct Launch {
    public struct State: Equatable {
        public init() { }
    }
    
    public enum Action: Equatable {
        public enum Delegate: Equatable {
            case showMainView(User)
            case showSignInView
        }
        
        case delegate(Delegate)
        
        case onAppear
        case fetchUser
    }
    
    @Dependency(\.userDefaultsClient) private var userDefaultsClient
    
    public var body: some Reducer<State, Action> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                return .send(.fetchUser)
                
            case .fetchUser:
                let user = userDefaultsClient.user()
                if let user {
                    return .send(.delegate(.showMainView(user)))
                } else {
                    return .send(.delegate(.showSignInView))
                }
                
            case .delegate:
                return .none
            }
        }
    }
}