import ComposableArchitecture
import Foundation

@Reducer
public struct Root {
    public struct State: Equatable {
        public init() {}
        
        @PresentationState var destination: Destination.State? = .launch(.init())
    }
    
    public enum Action: Equatable {
        case destination(PresentationAction<Destination.Action>)
        
        case onAppear
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                return .none
                
            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination()
        }
    }
}

// MARK: Destination
extension Root {
    @Reducer
    public struct Destination {
        public enum State: Equatable {
            case launch(Launch.State)
        }
        
        public enum Action: Equatable {
            case launch(Launch.Action)
        }
        
        public init() { }
        
        public var body: some ReducerOf<Self> {
            Scope(state: \.launch, action: \.launch) {
                Launch()
            }
        }
    }
}
