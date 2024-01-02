import SwiftUI
import ComposableArchitecture
import SharedUIs
import SharedModels

public struct SignInView: View {
    public init(store: StoreOf<SignIn>) {
        self.store = store
    }
    
    @FocusState private var focusedField: SignIn.State.Field?
    private let store: StoreOf<SignIn>
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
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
                            
                            TextField(#localized("Email"), text: viewStore.$email)
                                .textFieldStyle(.icon(#img("icon_email")))
                                .focused($focusedField, equals: .email)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(#localized("Password"))
                                .font(.customSubHeadline)
                                .foregroundStyle(#color("secondary"))
                            
                            passwordTextField(viewStore)
                        }
                        
                        signInButton(viewStore)
                        
                        separator
                        
                        Text(#localized("Forgot Password"))
                            .font(.customSubHeadline)
                            .foregroundStyle(#color("secondary"))
                            .onTapGesture {
                                viewStore.send(.forgotPasswordButtonTapped)
                            }
                    }
                    .padding(30)
                    .padding()
                    .bind(viewStore.$focusedField, to: self.$focusedField)
                }
                .splineBackground()
                .onTapGesture(count: 2) {
                    viewStore.send(.viewTappedTwice)
                }
                .dismissKeyboardOnTap()
                .loadingView(viewStore.isLoading)
                .navigationDestination(
                    store: store.scope(state: \.$destination.forgotPassword, action: \.destination.forgotPassword),
                    destination: ForgotPasswordView.init(store:)
                )
                .navigationDestination(
                    store: store.scope(state: \.$destination.createUser, action: \.destination.createUser),
                    destination: CreateUserView.init(store:)
                )
                .fullScreenCover(store: store.scope(state: \.$destination.adminPasswordInput, action: \.destination.adminPasswordInput)) { store in
                    AdminPasswordInputView(store: store)
                        .presentationBackground(Color.clear)
                }
                .alert(
                    store: store.scope(state: \.$destination.alert, action: \.destination.alert)
                )
            }
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
    private func passwordTextField(_ viewStore: ViewStoreOf<SignIn>) -> some View {
        Group {
            if viewStore.isSecure {
                SecureField(#localized("Password"), text: viewStore.$password)
            } else {
                TextField(#localized("Password"), text: viewStore.$password)
            }
        }
        .textFieldStyle(
            .secure(#img("icon_lock"), isSecure: viewStore.isSecure) {
                viewStore.send(.isSecureButtonTapped)
            }
        )
        .focused($focusedField, equals: .password)
    }
    
    private func signInButton(_ viewStore: ViewStoreOf<SignIn>) -> some View {
        Button {
            viewStore.send(.signInButtonTapped)
        } label: {
            HStack {
                Image(systemName: "arrow.right")
                Text(#localized("Sign In"))
                    .font(.customHeadline)
            }
            .largeButton()
        }
        .disabled(!viewStore.isValidInput)
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
