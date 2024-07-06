import SwiftUI
import ComposableArchitecture
import SharedUIs

public struct ForgotPasswordView: View {
    public init(store: StoreOf<ForgotPassword>) {
        self.store = store
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @FocusState private var focusedField: ForgotPassword.State.Field?
    @Bindable private var store: StoreOf<ForgotPassword>
    
    public var body: some View {
        ZStack {
            VStack(spacing: 24) {
                Text(#localized("Forgot Password"))
                    .font(.customLargeTitle)
                    .minimumScaleFactor(0.1)
                    .lineLimit(1)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(#localized("Reset your password by entering the email of your account, and follow the instructions sent to that email."))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(#color("secondary"))
                    .fixedSize(horizontal: false, vertical: true)
                
                VStack(alignment: .leading) {
                    Text(#localized("Email"))
                        .font(.customSubHeadline)
                        .foregroundStyle(#color("secondary"))
                    
                    TextField(#localized("Email"), text: $store.email)
                        .textFieldStyle(.icon(#img("icon_email")))
                        .keyboardType(.emailAddress)
                        .focused($focusedField, equals: .email)
                }
                
                forgotPasswordButton
            }
            .padding(30)
            .padding()
            .bind($store.focusedField, to: self.$focusedField)
            
            closeButton
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(20)
        }
        .navigationBarHidden(true)
        .splineBackground()
        .dismissKeyboardOnTap()
        .loadingView(store.isLoading)
        .alert(
            $store.scope(state: \.destination?.alert, action: \.destination.alert)
        )
    }
}

// MARK: Views Parts
extension ForgotPasswordView {
    private var background: some View {
        #img("img_spline")
            .blur(radius: 60)
            .offset(x: 200, y: 100)
    }
    
    private var closeButton: some View {
        Button {
            // TODO: When @Dependency(\.dismiss) is used view is emptied when animation starts.
            self.presentationMode.wrappedValue.dismiss()
            // viewStore.send(.closeButtonTapped)
        } label: {
            Image(systemName: "xmark")
                .foregroundColor(.white)
                .frame(width: 36, height: 36)
                .background(.black)
                .mask(Circle())
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 10)
        }
    }
    
    private var forgotPasswordButton: some View {
        Button {
            store.send(.forgotPasswordButtonTapped)
        } label: {
            HStack {
                Image(systemName: "arrow.right")
                Text(#localized("Send Email"))
                    .font(.customHeadline)
            }
            .largeButton()
        }
        .disabled(!store.isValidInput)
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
