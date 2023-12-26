import Foundation
import SwiftUI
import ComposableArchitecture

@Reducer
public struct ColorPalette {
    public struct State: Equatable {
        public init() { }
        
        var selectedColor: Color = .clear
    }
    
    public enum Action: Equatable {
        public enum Delegate: Equatable {
            case colorSelected(Color)
        }
        
        case delegate(Delegate)
        case viewTappedOn(Color)
    }
    
    public init() { }
    
    public var body: some
    ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .viewTappedOn(let color):
                state.selectedColor = color
                return .send(.delegate(.colorSelected(state.selectedColor)))
                
            case .delegate:
                return .none
            }
        }
    }
}
