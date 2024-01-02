import SwiftUI
import ComposableArchitecture
import SharedUIs

public struct SignedInView: View {
    public init(store: StoreOf<SignedIn>) {
        self.store = store
    }
    
    private let store: StoreOf<SignedIn>
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Text(viewStore.state.userSession.user.username)
        }
    }
}

#Preview {
    SignedInView(
        store: .init(
            initialState: .init(userSession: .mock),
            reducer: SignedIn.init
        )
    )
}
