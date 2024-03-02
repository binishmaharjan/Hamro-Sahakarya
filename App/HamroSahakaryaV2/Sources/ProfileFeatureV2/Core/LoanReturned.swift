import Foundation
import ComposableArchitecture
import SharedModels

@Reducer
public struct LoanReturned {
    @ObservableState
    public struct State: Equatable {
        public init(admin: User) {
            self.admin = admin
        }
        
        var admin: User
    }
    
    public enum Action {
        
    }
    
    public init() { }
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            return .none
        }
    }
}