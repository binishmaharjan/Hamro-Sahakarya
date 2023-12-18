import SwiftUI
import ComposableArchitecture
import SharedUIs

public struct ForgotPasswordView: View {
    public init(store: StoreOf<ForgotPassword>) {
        self.store = store
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @FocusState private var focusedField: ForgotPassword.State.Field?
    private let store: StoreOf<ForgotPassword>
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                VStack(spacing: 24) {
                    Text(#localized("Forgot Password"))
                        .font(.customLargeTitle)
                    
                    Text(#localized("Reset your password by entering the email of your account, and follow the instructions sent to that email."))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(#color("secondary"))
                        .fixedSize(horizontal: false, vertical: true)
                    
                    VStack(alignment: .leading) {
                        Text(#localized("Email"))
                            .font(.customSubHeadline)
                            .foregroundStyle(#color("secondary"))
                        
                        TextField("", text: viewStore.$email)
                            .customTextField(image: #img("icon_email"))
                            .focused($focusedField, equals: .email)
                    }
                    
                    forgotPasswordButton(viewStore)
                }
                .padding(30)
                .padding()
                .bind(viewStore.$focusedField, to: self.$focusedField)
                
                Button {
                    // TODO: When @Dependency(\.dismiss) is used view is emptied when animation starts.
                    // TODO: Find a fix
                    self.presentationMode.wrappedValue.dismiss()
//                    viewStore.send(.closeButtonTapped)
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .frame(width: 36, height: 36)
                        .background(.black)
                        .mask(Circle())
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 10)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(20)
            }
            .navigationBarHidden(true)
            .frame(maxHeight: .infinity)
            .background(.ultraThinMaterial)
            .background(background)
        }
    }
}

// MARK: Views Parts
extension ForgotPasswordView {
    private var background: some View {
        #img("img_spline")
            .blur(radius: 60)
            .offset(x: 200, y: 100)
    }
    
    private func forgotPasswordButton(_ viewStore: ViewStoreOf<ForgotPassword>) -> some View {
        Button {
            viewStore.send(.forgotPasswordButtonTapped)
        } label: {
            HStack {
                Image(systemName: "arrow.right")
                Text(#localized("Forgot Password"))
                    .font(.customHeadline)
            }
            .largeButton()
        }
        .disabled(!viewStore.isValidInput)
    }
}

#Preview {
    ForgotPasswordView(
        store: .init(
            initialState: .init(),
            reducer: ForgotPassword.init
        )
    )
}
