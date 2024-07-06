import SwiftUI
import ComposableArchitecture
import SharedUIs
import SharedModels

public struct MembersListView: View {
    public init(store: StoreOf<MembersList>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<MembersList>
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                ForEach(store.members) { member in
                    MemberItemView(member: member)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                        .background(#color("white"))
                        .mask(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        .shadow(color: #color("background2").opacity(0.1), radius: 10, x: 0, y: 1)
                        .padding(.horizontal, 20)
                }
            }
            .padding(.top, 16)
        }
        .customNavigationBar(#localized("Members"))
        .background(#color("background"))
        .loadingView(store.isLoading)
        .onAppear { store.send(.onAppear) }
        .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
    }
}

#Preview {
    MembersListView(
        store: .init(
            initialState: .init(members: [.mock, .mock, .mock]),
            reducer: MembersList.init
        )
    )
}
