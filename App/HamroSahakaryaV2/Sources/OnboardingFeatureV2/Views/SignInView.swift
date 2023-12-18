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
                        
                        Text("Don't have an account yet, Please contact the administrator to request an account.")
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
                        
                        VStack(alignment: .leading) {
                            Text(#localized("Password"))
                                .font(.customSubHeadline)
                                .foregroundStyle(#color("secondary"))
                            
                            SecureField("", text: viewStore.$password)
                                .customTextField(image: #img("icon_lock"))
                                .focused($focusedField, equals: .password)
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
                .frame(maxHeight: .infinity)
                .background(.ultraThinMaterial)
                .background(background)
                .navigationDestination(
                    store: store.scope(state: \.$destination.forgotPassword, action: \.destination.forgotPassword),
                    destination: ForgotPasswordView.init(store:)
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
