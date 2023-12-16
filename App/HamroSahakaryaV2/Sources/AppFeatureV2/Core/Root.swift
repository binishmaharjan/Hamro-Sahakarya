import ComposableArchitecture
import Foundation

@Reducer
public struct Root {
    public struct State: Equatable {

        public init() {
        }
    }
    
    public enum Action: Equatable {
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            }
            return .none
        }
    }
}
