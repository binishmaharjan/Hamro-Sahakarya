import Foundation
import SwiftUI
import ComposableArchitecture

public typealias ColorHex = String

@Reducer
public struct ColorPicker {
    public struct State: Equatable {
        public init() { }
        
        var colorHex: ColorHex = ""
    }
    
    public enum Action: Equatable {
        public enum Delegate: Equatable {
            case colorSelected(ColorHex)
        }
        
        case delegate(Delegate)
        case selectButtonTapped
    }
    
    public init() { }
    
    public var body: some
    ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .selectButtonTapped:
                return .send(.delegate(.colorSelected(state.colorHex)))
                
            case .delegate:
                return .none
            }
        }
    }
}
