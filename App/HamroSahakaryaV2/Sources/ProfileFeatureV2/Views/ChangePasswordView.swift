import SwiftUI
import ComposableArchitecture
import SharedUIs

public struct ChangePasswordView: View {
    public init(store: StoreOf<ChangePassword>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<ChangePassword>
    
    public var body: some View {
        VStack(spacing: 24) {
            VStack(alignment: .leading) {
                Text(#localized("New Password"))
                    .font(.customSubHeadline)
                    .foregroundStyle(#color("secondary"))
                
                TextField(#localized("New Password"), text: $store.password)
                    .textFieldStyle(.icon(#img("icon_lock")))
                    .textInputAutocapitalization(.never)
            }
            
            VStack(alignment: .leading) {
                Text(#localized("Confirm Password"))
                    .font(.customSubHeadline)
                    .foregroundStyle(#color("secondary"))
                
                TextField(#localized("Confirm Password"), text: $store.confirmPassword)
                    .textFieldStyle(.icon(#img("icon_lock")))
                    .textInputAutocapitalization(.never)
            }
            
            changePasswordButton
            
            Spacer()
        }
        .padding(20)
        .padding()
        .background(#color("background"))
        .customNavigationBar(#localized("Change Password"))
        .loadingView(store.isLoading)
        .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
    }
}

// MARK: View Parts
extension ChangePasswordView {
    private var changePasswordButton: some View {
        Button {
            store.send(.changePasswordTapped)
        } label: {
            HStack {
                Image(systemName: "arrow.right")
                Text(#localized("Change Password"))
                    .font(.customHeadline)
            }
            .largeButton()
        }
        .disabled(!store.isValidInput)
    }
}

#Preview {
    ChangePasswordView(
        store: .init(
            initialState: .init(user: .mock),
            reducer: ChangePassword.init
        )
    )
}
