import SwiftUI
import ComposableArchitecture
import OnboardingFeatureV2
import SignedInFeatureV2

// MARK: ViewState
extension RootView {
    struct ViewState: Equatable {
        var destination: Root.Destination.State?
        
        init(state: Root.State) {
            destination = state.destination
        }
    }
}


// MARK: View
public struct RootView: View {
    public init(store: StoreOf<Root>) {
        self.store = store
    }
    
    private let store: StoreOf<Root>
    
    public var body: some View {
        WithViewStore(store, observe: ViewState.init) { viewStore in
            ZStack {
                IfLetStore(store.scope(state: \.$destination, action: \.destination)) { store in
                    SwitchStore(store) { initialState in
                        switch initialState {
                            // Launch View
                        case .launch:
                            CaseLet(\Root.Destination.State.launch, action: Root.Destination.Action.launch) { launchStore in
                                LaunchView(store: launchStore)
                            }
                            
                        case .signIn:
                            CaseLet(\Root.Destination.State.signIn, action: Root.Destination.Action.signIn) { signInStore in
                                SignInView(store: signInStore)
                            }
                            
                        case .signedIn:
                            CaseLet(\Root.Destination.State.signedIn, action: Root.Destination.Action.signedIn) { signedInStore in
                                SignedInView(store: signedInStore)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    RootView(
        store: .init(
            initialState: .init(),
            reducer: Root.init
        )
    )
}
