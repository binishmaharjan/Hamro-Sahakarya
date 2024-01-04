import SwiftUI
import ComposableArchitecture
import SharedUIs

public struct HomeView: View {
    public init(store: StoreOf<Home>) {
        self.store = store
    }
    
    private let store: StoreOf<Home>
    
    public var body: some View {
        VStack {
            Text("Home")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(#color("background"))
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
