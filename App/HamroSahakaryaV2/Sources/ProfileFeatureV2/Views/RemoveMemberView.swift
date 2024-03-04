import SwiftUI
import ComposableArchitecture
import SharedUIs

public struct RemoveMemberView: View {
    public init(store: StoreOf<RemoveMember>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<RemoveMember>
    
    public var body: some View {
        VStack(spacing: 24) {
            VStack {
                Text(#localized("Select Target Members"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.customSubHeadline2)
                    .foregroundStyle(#color("gray"))
                
                MemberSelectView(store: store.scope(state: \.memberSelect, action: \.memberSelect))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            removeButton
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(20)
        .padding()
        .background(#color("background"))
        .customNavigationBar(#localized("Remove Member"))
        .loadingView(store.isLoading)
        .onAppear { store.send(.onAppear) }
        .alert(
            $store.scope(state: \.destination?.alert, action: \.destination.alert)
        )
    }
}

// MARK: View Parts
extension RemoveMemberView {
    private var removeButton: some View {
        Button {
            store.send(.removeMemberTapped)
        } label: {
            HStack {
                Image(systemName: "arrow.right")
                Text(#localized("Remove Member"))
                    .font(.customHeadline)
            }
            .largeButton()
        }
        .disabled(!store.isValidInput)
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
