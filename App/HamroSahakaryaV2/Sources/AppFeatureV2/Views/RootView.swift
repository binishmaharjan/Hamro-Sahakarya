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
        ZStack {
            if let store = store.scope(state: \.destination, action: \.destination) {
                switch store.state {
                case .launch:
                    if let launchStore = store.scope(state: \.launch, action: \.launch) {
                        LaunchView(store: launchStore)
                    }
                case .signIn:
                    if let signInStore = store.scope(state: \.signIn, action: \.signIn) {
                        SignInView(store: signInStore)
                    }
                case .signedIn:
                    if let signedInStore = store.scope(state: \.signedIn, action: \.signedIn) {
                        SignedInView(store: signedInStore)
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
