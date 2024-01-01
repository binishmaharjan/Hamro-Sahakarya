import SwiftUI
import ComposableArchitecture
import SharedUIs

public struct AdminPasswordInputView: View {
    public init(store: StoreOf<AdminPasswordInput>) {
        self.store = store
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    private let store: StoreOf<AdminPasswordInput>
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 24) {
                Text(#localized("Admin Password"))
                    .font(.customLargeTitle)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                    .fixedSize(horizontal: false, vertical: true)
                
                VStack(alignment: .leading) {
                    Text(#localized("Enter Admin Password"))
                        .font(.customSubHeadline)
                        .foregroundStyle(#color("secondary"))
                    
                    
                    SecureField(#localized("Admin Password"), text: viewStore.$password)
                        .textFieldStyle(.icon(#img("icon_lock")))
                }
                
                enterButton(viewStore)
            }
            .padding(30)
            .background(.regularMaterial)
            .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: #color("shadow").opacity(0.3), radius: 5, x: 0, y: 3)
            .shadow(color: #color("shadow").opacity(0.3), radius: 30, x: 0, y: 30)
            .overlay(
                closeButton(viewStore)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .offset(x: 18, y: -18)
            )
            .padding(.horizontal, 32)
        }
    }
}

// MARK: Views Parts
extension AdminPasswordInputView {
    
    private func closeButton(_ viewStore: ViewStoreOf<AdminPasswordInput>) -> some View {
        Button {
            viewStore.send(.closeButtonTapped)
        } label: {
            Image(systemName: "xmark")
                .frame(width: 36, height: 36)
                .foregroundColor(#color("white"))
                .background(#color("black"))
                .mask(Circle())
                .shadow(color: #color("shadow").opacity(0.3), radius: 5, x: 0, y: 3)
        }
    }
    
    private func enterButton(_ viewStore: ViewStoreOf<AdminPasswordInput>) -> some View {
        Button {
            viewStore.send(.enterButtonTapped)
        } label: {
            HStack {
                Image(systemName: "arrow.right")
                Text(#localized("Enter"))
                    .font(.customHeadline)
            }
            .largeButton()
        }
        .disabled(!viewStore.isValidPassword)
    }
}

#Preview {
    AdminPasswordInputView(
        store: .init(
            initialState: .init(),
            reducer: AdminPasswordInput.init
        )
    )
}
