import SwiftUI
import ComposableArchitecture
import SharedUIs

public struct LoginView: View {
    public init(store: StoreOf<Login>) {
        self.store = store
    }
    
    private let store: StoreOf<Login>
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 24) {
                Text("Login View")
            }
            .background(background)
        }
    }
}

// MARK: Views Parts
extension LoginView {
    private var background: some View {
        #img("img_spline")
            .blur(radius: 60)
            .offset(x: 200, y: 100)
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
