import SwiftUI
import ComposableArchitecture
import SharedUIs
import SharedModels

public struct SignInView: View {
    public init(store: StoreOf<SignIn>) {
        self.store = store
    }
    
    @FocusState private var focusedField: SignIn.State.Field?
    @Bindable private var store: StoreOf<SignIn>
    
    public var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 24) {
                    Text(#localized("Sign In"))
                        .font(.customLargeTitle)
                        .lineLimit(1)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text("Don't have an account yet, Please contact the administrator to request an account.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(#color("secondary"))
                        .fixedSize(horizontal: false, vertical: true)
                    
                    VStack(alignment: .leading) {
                        Text(#localized("Email"))
                            .font(.customSubHeadline)
                            .foregroundStyle(#color("secondary"))
                        
                        TextField(#localized("Email"), text: $store.email)
                            .textFieldStyle(.icon(#img("icon_email")))
                            .focused($focusedField, equals: .email)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(#localized("Password"))
                            .font(.customSubHeadline)
                            .foregroundStyle(#color("secondary"))
                        
                        passwordTextField
                    }
                    
                    signInButton
                    
                    separator
                    
                    Text(#localized("Forgot Password"))
                        .font(.customSubHeadline)
                        .foregroundStyle(#color("secondary"))
                        .onTapGesture {
                            store.send(.forgotPasswordButtonTapped)
                        }
                }
                .padding(30)
                .padding()
                .bind($store.focusedField, to: self.$focusedField)
            }
            .splineBackground()
            .onTapGesture(count: 2) {
                store.send(.viewTappedTwice)
            }
            .dismissKeyboardOnTap()
            .loadingView(store.isLoading)
            .navigationDestination(
                item: $store.scope(state: \.destination?.forgotPassword, action: \.destination.forgotPassword),
                destination: ForgotPasswordView.init(store:)
            )
            .navigationDestination(
                item: $store.scope(state: \.destination?.createUser, action: \.destination.createUser),
                destination: CreateUserView.init(store:)
            )
            .fullScreenCover(
                item: $store.scope(state: \.destination?.adminPasswordInput, action: \.destination.adminPasswordInput)
            ) { store in
                AdminPasswordInputView(store: store)
                    .presentationBackground(Color.clear)
            }
            .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
        }
    }
}

// MARK: Views Parts
extension SignInView {
    private var background: some View {
        #img("img_spline")
            .blur(radius: 60)
            .offset(x: 200, y: 100)
    }
    
    private var separator: some View {
        HStack {
            Rectangle()
                .frame(height: 1)
                .opacity(0.1)
            
            Text(#localized("OR"))
                .font(.customSubHeadline2)
                .foregroundStyle(#color("black").opacity(0.3))
            
            Rectangle()
                .frame(height: 1)
                .opacity(0.1)
        }
    }
    
    @MainActor
    private var passwordTextField: some View {
        Group {
            if store.isSecure {
                SecureField(#localized("Password"), text: $store.password)
            } else {
                TextField(#localized("Password"), text: $store.password)
            }
        }
        .textFieldStyle(
            .secure(#img("icon_lock"), isSecure: store.isSecure) {
                store.send(.isSecureButtonTapped)
            }
        )
        .focused($focusedField, equals: .password)
    }
    
    private var signInButton: some View {
        Button {
            store.send(.signInButtonTapped)
        } label: {
            HStack {
                Image(systemName: "arrow.right")
                Text(#localized("Sign In"))
                    .font(.customHeadline)
            }
            .largeButton()
        }
        .disabled(!store.isValidInput)
    }
}

#Preview {
    SignInView(
        store: .init(
            initialState: .init(),
            reducer: SignIn.init
        )
    )
}
