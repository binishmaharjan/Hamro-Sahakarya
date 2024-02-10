import Foundation
import ComposableArchitecture

@Reducer
public struct Profile {
    @ObservableState
    public struct State: Equatable {
        public init() { }
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
