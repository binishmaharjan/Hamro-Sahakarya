import SwiftUI
import ComposableArchitecture

public struct LoginView: View {
    public init(store: StoreOf<Login>) {
        self.store = store
    }
    
    private let store: StoreOf<Login>
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Text("Login View")
        }
    }
}

#Preview {
    LoginView(
        store: .init(
            initialState: .init(),
            reducer: Login.init
        )
    )
}
