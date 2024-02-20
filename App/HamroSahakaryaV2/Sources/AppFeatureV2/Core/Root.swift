import ComposableArchitecture
import Foundation
import UserSession
import OnboardingFeatureV2
import SignedInFeatureV2

@Reducer
public struct Root {
    @ObservableState
    public struct State: Equatable {
        public init() {}
        
        @Presents var destination: Destination.State? = .launch(.init())
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
                
            case .destination(.presented(.launch(.delegate(.showMainView(let user))))),
                 .destination(.presented(.signIn(.delegate(.authenticationSuccessful(let user))))):
                let userSession = UserSession.createUserSession(from: user)
                state.destination = .signedIn(.init(userSession: userSession))
                return .none
                
            case .destination(.presented(.signedIn(.profile(.delegate(.signOutSuccessful))))),
                 .destination(.presented(.signedIn(.profile(.destination(.presented(.changePassword(.delegate(.signOutSuccessful)))))))):
                state.destination = .signIn(.init())
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
        @ObservableState
        public enum State: Equatable {
            case launch(Launch.State)
            case signIn(SignIn.State)
            case signedIn(SignedIn.State)
        }
        
        public enum Action: Equatable {
            case launch(Launch.Action)
            case signIn(SignIn.Action)
            case signedIn(SignedIn.Action)
        }
        
        public init() { }
        
        public var body: some ReducerOf<Self> {
            Scope(state: \.launch, action: \.launch) {
                Launch()
            }
            Scope(state: \.signIn, action: \.signIn) {
                SignIn()
            }
            Scope(state: \.signedIn, action: \.signedIn) {
                SignedIn()
            }
        }
    }
}
