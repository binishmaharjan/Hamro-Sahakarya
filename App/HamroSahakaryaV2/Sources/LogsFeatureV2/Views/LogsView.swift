import SwiftUI
import ComposableArchitecture
import SharedUIs

public struct LogsView: View {
    public init(store: StoreOf<Logs>) {
        self.store = store
    }
    
    private let store: StoreOf<Logs>
    
    public var body: some View {
        NavigationView {
            VStack {
                Text("Hello World")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarHidden(true)
            .background(#color("background"))
        }
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
