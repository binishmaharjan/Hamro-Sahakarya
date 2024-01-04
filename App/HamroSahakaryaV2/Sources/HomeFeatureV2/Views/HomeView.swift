import SwiftUI
import ComposableArchitecture

public struct HomeView: View {
    public init(store: StoreOf<Home>) {
        self.store = store
    }
    
    private let store: StoreOf<Home>
    
    public var body: some View {
        Text("Home")
    }
}

#Preview {
    HomeView(
        store: .init(
            initialState: .init(),
            reducer: Home.init
        )
    )
}
