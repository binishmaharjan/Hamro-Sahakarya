import Foundation
import ComposableArchitecture
import SharedModels
import UserSession

@Reducer
public struct SignedIn {
    public struct State: Equatable {
        public init(userSession: UserSession) {
            self.userSession = userSession
        }
        
        public var userSession: UserSession
    }
    
    public enum Action: Equatable {
        
    }
    
    public init() { }
    
    public var body: some
    ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            return .none
        }
    }
}
