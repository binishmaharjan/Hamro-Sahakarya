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
            case showMainView(Account)
            case showSignInView
        }
        
        case delegate(Delegate)
        
        case onAppear
        case fetchUserAccount
    }
    
    @Dependency(\.userDefaultsClient) private var userDefaultsClient
    
    public var body: some Reducer<State, Action> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                return .send(.fetchUserAccount)
                
            case .fetchUserAccount:
                let userAccount = userDefaultsClient.userAccount()
                if let userAccount {
                    return .send(.delegate(.showMainView(userAccount)))
                } else {
                    return .send(.delegate(.showSignInView))
                }
                
            case .delegate:
                return .none
            }
        }
    }
}
