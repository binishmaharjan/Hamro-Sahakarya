import SwiftUI
import ComposableArchitecture

public struct ProfileView: View {
    public init(store: StoreOf<Profile>) {
        self.store = store
    }
    
    private let store: StoreOf<Profile>
    
    public var body: some View {
        Text("Profile")
    }
}

#Preview {
    ProfileView(
        store: .init(
            initialState: .init(),
            reducer: Profile.init
        )
    )
}
