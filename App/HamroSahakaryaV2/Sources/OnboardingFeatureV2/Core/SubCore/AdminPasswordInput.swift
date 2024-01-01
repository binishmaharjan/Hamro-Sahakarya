
import Foundation
import ComposableArchitecture
import ColorPaletteFeatureV2
import SharedUIs
import SharedModels

@Reducer
public struct AdminPasswordInput {
    public struct State: Equatable {
        public init() { }
        
        @BindingState var password: Password = ""
        
        var isValidPassword: Bool { !password.isEmpty }
    }
    
    public enum Action: BindableAction, Equatable {
        public enum Delegate: Equatable {
            case verifyAdminPassword(Password)
        }
        
        case binding(BindingAction<State>)
        case delegate(Delegate)
        
        case enterButtonTapped
        case closeButtonTapped
    }
    
    public init() { }
    
    @Dependency(\.dismiss) private var dismiss
    
    public var body: some
    ReducerOf<Self> {
        BindingReducer()
        
        Reduce<State, Action> { state, action in
            switch action {
            case .enterButtonTapped:
                return .send(.delegate(.verifyAdminPassword(state.password)))
                
            case .closeButtonTapped:
                return .run { _ in
                    await dismiss()
                }
                
            case .binding, .delegate:
                return .none
            }
        }
    }
}
