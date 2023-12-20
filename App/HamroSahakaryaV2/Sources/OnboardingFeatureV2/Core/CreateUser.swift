import Foundation
import ComposableArchitecture
import SharedModels

@Reducer
public struct CreateUser {
    public struct State: Equatable {
        @BindingState var email: String = ""
        @BindingState var fullname: String = ""
        @BindingState var password: String = ""
        @BindingState var status: Status = .member
        @BindingState var colorHex: String = ""
        @BindingState var initialAmount: String = "0"
    }
    
    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        
        case createUserButtonTapped
    }
    
    public init(){ }
    
    public var body: some
    ReducerOf<Self> {
        BindingReducer()
        
        Reduce<State, Action> { state, action in
            switch action {
            case .createUserButtonTapped:
                return .none
                
            case .binding:
                return .none
            }
        }
    }
}
