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
            case showLoginView
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
                return .none
                
            case .fetchUserAccount:
                return .none
                
            case .delegate:
                return .none
                
            }
        }
    }
}
