import SwiftUI
import ComposableArchitecture
import SharedModels
import SharedUIs

public struct UpdateNoticeView: View {
    public init(store: StoreOf<UpdateNotice>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<UpdateNotice>
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(alignment: .leading) {
                    Text(#localized("Type"))
                        .font(.customSubHeadline)
                        .foregroundStyle(#color("secondary"))
                    
                    TextField(#localized("Write something"), text: $store.notice, axis: .vertical)
                        .textFieldStyle(.bordered(height: 200))
                }
                
                updateButton
                
                Spacer()
            }
            .padding(20)
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .dismissKeyboardOnTap()
        .background(#color("background"))
        .customNavigationBar(#localized("Update Notice"))
        .loadingView(store.isLoading)
        .alert(
            $store.scope(state: \.destination?.alert, action: \.destination.alert)
        )
    }
}

// MARK: View Parts
extension UpdateNoticeView {
    private var updateButton: some View {
        Button {
            store.send(.updateButtonTapped)
        } label: {
            HStack {
                Image(systemName: "arrow.right")
                Text(#localized("Update Notice"))
                    .font(.customHeadline)
            }
            .largeButton()
        }
        .disabled(!store.isValidInput)
    }
}

#Preview {
    UpdateNoticeView(
        store: .init(
            initialState: .init(admin: .mock),
            reducer: UpdateNotice.init
        )
    )
}
