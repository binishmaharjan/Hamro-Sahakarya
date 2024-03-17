import ComposableArchitecture
import Foundation
import UserSession
import OnboardingFeatureV2
import SignedInFeatureV2

@Reducer
public struct Root {
    @Reducer(state: .equatable)
    public enum Destination {
        case launch(Launch)
        case signIn(SignIn)
        case signedIn(SignedIn)
    }

    @ObservableState
    public struct State: Equatable {
        public init() {}
        
        @Presents var destination: Destination.State? = .launch(.init())
    }
    
    public enum Action {
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
        .ifLet(\.$destination, action: \.destination)
    }
}
