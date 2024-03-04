import SwiftUI
import ComposableArchitecture

public struct RemoveMemberView: View {
    public init(store: StoreOf<RemoveMember>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<RemoveMember>
    
    public var body: some View {
        Text("Remove Member")
    }
}

#Preview {
    RemoveMemberView(
        store: .init(
            initialState: .init(admin: .mock),
            reducer: RemoveMember.init
        )
    )
}
