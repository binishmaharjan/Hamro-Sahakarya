import Foundation
import ComposableArchitecture

@Reducer
public struct Launch {
    public struct State: Equatable {
        public init() { }
        let a: String = ""
        
    }
    
    public enum Action: Equatable {
        case some
    }
    
    public var body: some Reducer<State, Action> {
        Reduce<State, Action> { state, action in
            return .none
        }
    }
}
