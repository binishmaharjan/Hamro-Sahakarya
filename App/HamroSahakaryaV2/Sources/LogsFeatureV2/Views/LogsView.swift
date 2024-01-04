import SwiftUI
import ComposableArchitecture

public struct LogsView: View {
    public init(store: StoreOf<Logs>) {
        self.store = store
    }
    
    private let store: StoreOf<Logs>
    
    public var body: some View {
        Text("Logs")
    }
}

#Preview {
    LogsView(
        store: .init(
            initialState: .init(),
            reducer: Logs.init
        )
    )
}
