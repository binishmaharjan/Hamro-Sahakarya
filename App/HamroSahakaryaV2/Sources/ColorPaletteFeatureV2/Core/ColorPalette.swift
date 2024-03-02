import Foundation
import ComposableArchitecture
import SharedUIs
import SwiftHelpers

@Reducer
public struct ColorPalette {
    @ObservableState
    public struct State: Equatable {
        public init() { }
        
        var selectedColorHex: ColorHex = ""
    }
    
    public enum Action {
        @CasePathable
        public enum Delegate: Equatable {
            case colorSelected(ColorHex)
        }
        
        case delegate(Delegate)
        case viewTappedOn(ColorHex)
    }
    
    public init() { }
    
    public var body: some
    ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .viewTappedOn(let colorHex):
                state.selectedColorHex = colorHex
                return .send(.delegate(.colorSelected(state.selectedColorHex)))
                
            case .delegate:
                return .none
            }
        }
    }
}
