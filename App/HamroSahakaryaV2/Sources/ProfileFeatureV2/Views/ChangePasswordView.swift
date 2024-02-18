import SwiftUI
import ComposableArchitecture

public struct ChangePasswordView: View {
    public init(store: StoreOf<ChangePassword>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<ChangePassword>
    
    public var body: some View {
        Text("ChangePassword View")
    }
}

#Preview {
    ChangePasswordView(
        store: .init(
            initialState: .init(),
            reducer: ChangePassword.init
        )
    )
}
