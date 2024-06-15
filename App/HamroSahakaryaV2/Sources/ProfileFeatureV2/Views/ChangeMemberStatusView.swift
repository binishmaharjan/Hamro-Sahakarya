import SwiftUI
import ComposableArchitecture
import SharedUIs

public struct ChangeMemberStatusView: View {
    public init(store: StoreOf<ChangeMemberStatus>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<ChangeMemberStatus>
    
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
            
            changeMemberStatusButton
        }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(20)
            .padding()
            .background(#color("background"))
            .customNavigationBar(#localized("Change Member Status"))
            .loadingView(store.isLoading)
            .onAppear { store.send(.onAppear) }
            .alert(
                $store.scope(state: \.destination?.alert, action: \.destination.alert)
            )
    }
}

// MARK: View Parts
extension ChangeMemberStatusView {
    private var changeMemberStatusButton: some View {
        Button {
            store.send(.changeMemberStatusTapped)
        } label: {
            HStack {
                Image(systemName: "arrow.right")
                Text(#localized("Change Member Status"))
                    .font(.customHeadline)
            }
            .largeButton()
        }
        .disabled(!store.isValidInput)
    }
}

#Preview {
    ChangeMemberStatusView(
        store: .init(
            initialState: .init(admin: .mock),
            reducer: ChangeMemberStatus.init
        )
    )
}
