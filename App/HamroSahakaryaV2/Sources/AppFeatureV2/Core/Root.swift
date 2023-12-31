import ComposableArchitecture
import Foundation
import OnboardingFeatureV2

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
            case .destination(.presented(.launch(.delegate(.showSignInView)))):
                state.destination = .signIn(.init())
                return .none

            case let .destination(.presented(.launch(.delegate(.showMainView(user))))):
                print("Show Main")
                return .none
                
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
            case signIn(SignIn.State)
        }
        
        public enum Action: Equatable {
            case launch(Launch.Action)
            case signIn(SignIn.Action)
        }
        
        public init() { }
        
        public var body: some ReducerOf<Self> {
            Scope(state: \.launch, action: \.launch) {
                Launch()
            }
            Scope(state: \.signIn, action: \.signIn) {
                SignIn()
            }
        }
    }
}
