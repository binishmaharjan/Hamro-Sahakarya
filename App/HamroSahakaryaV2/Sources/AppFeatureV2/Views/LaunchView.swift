import SwiftUI
import ComposableArchitecture

public struct LaunchView: View {
    public init(store: StoreOf<Launch>) {
        self.store = store
    }
    
    private let store: StoreOf<Launch>
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                Text("LaunchView")
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

#Preview {
    LaunchView(
        store: .init(
            initialState: .init(),
            reducer: Launch.init
        )
    )
}
