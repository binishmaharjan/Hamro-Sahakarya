import Foundation
import SwiftUI
import ComposableArchitecture

@Reducer
public struct ColorPalette {
    public struct State: Equatable {
        public init() { }
    }
    
    public enum Action: Equatable {
        public enum Delegate: Equatable {
            case colorSelected(Color)
        }
        
        case delegate(Delegate)
    }
    
    public init() { }
    
    public var body: some
    ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            return .none
        }
    }
}
