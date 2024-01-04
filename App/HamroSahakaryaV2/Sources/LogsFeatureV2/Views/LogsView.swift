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
                ScrollView {
                    Text("Hello World")
                }
                .frame(maxWidth: .infinity)
            }
            .navigationTitle("Logs")
            .navigationBarTitleDisplayMode(.inline)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(#color("background"))
        }
    }
}

#Preview {
    NavigationView{
        LogsView(
            store: .init(
                initialState: .init(),
                reducer: Logs.init
            )
        )
    }
}
