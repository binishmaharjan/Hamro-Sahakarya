import Foundation
import ComposableArchitecture
import SharedModels

@Reducer
public struct CreateUser {
    public struct State: Equatable {
        
    }
    
    public enum Action: Equatable {
        
    }
    
    public init(){ }
    
    public var body: some
    ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            return .none
        }
    }
}
