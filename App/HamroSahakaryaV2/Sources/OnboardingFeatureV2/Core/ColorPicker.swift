import Foundation
import ComposableArchitecture
import ColorPaletteFeatureV2
import SharedUIs

@Reducer
public struct ColorPicker {
    public struct State: Equatable {
        public init() { }
        
        var colorPalette = ColorPalette.State()
        var colorHex: ColorHex = "#000000"
    }
    
    public enum Action: Equatable {
        public enum Delegate: Equatable {
            case colorSelected(ColorHex)
            case close
        }
        
        case delegate(Delegate)
        
        case colorPalette(ColorPalette.Action)
        case selectButtonTapped
        case closeButtonTapped
    }
    
    public init() { }
    
    public var body: some
    ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .selectButtonTapped:
                return .send(.delegate(.colorSelected(state.colorHex)))
                
            case .colorPalette(.delegate(.colorSelected(let colorHex))):
                state.colorHex = colorHex
                return .none
                
            case .closeButtonTapped:
                return .send(.delegate(.close))
                
            case .delegate, .colorPalette:
                return .none
            }
        }
        
        Scope(state: \.colorPalette, action: \.colorPalette) {
            ColorPalette()
        }
    }
}
