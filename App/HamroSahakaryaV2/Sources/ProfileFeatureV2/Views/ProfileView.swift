import SwiftUI
import ComposableArchitecture
import SharedUIs

public struct ProfileView: View {
    public init(store: StoreOf<Profile>) {
        self.store = store
    }
    
    private let store: StoreOf<Profile>
    
    public var body: some View {
        VStack {
            Text("Profile")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(#color("background"))
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
