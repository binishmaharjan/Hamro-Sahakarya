import SwiftUI
import ComposableArchitecture

public struct RootView: View {
    public init(store: StoreOf<Root>) {
        self.store = store
    }
    
    private let store: StoreOf<Root>
    
    public var body: some View {
        Text("Root View")
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
