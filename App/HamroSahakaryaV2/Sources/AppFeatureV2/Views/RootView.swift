import SwiftUI
import ComposableArchitecture

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
                        case .launch:
                            CaseLet(
                                \Root.Destination.State.launch,
                                 action: Root.Destination.Action.launch
                            ) { launchStore in
                                LaunchView(store: launchStore)
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
