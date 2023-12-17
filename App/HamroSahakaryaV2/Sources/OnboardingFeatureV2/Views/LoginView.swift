import SwiftUI
import ComposableArchitecture
import SharedUIs

public struct LoginView: View {
    public init(store: StoreOf<Login>) {
        self.store = store
    }
    
    @FocusState var focusedField: Login.State.Field?
    private let store: StoreOf<Login>
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                VStack(spacing: 24) {
                    Text(#localized("Login"))
                        .font(.customLargeTitle)
                    
                    Text("Don't have an account yet, Please contact the administrator to request an account.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(#color("secondary"))
                    
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
                        
                        SecureField("", text:viewStore.$password)
                            .customTextField(image: #img("icon_lock"))
                            .focused($focusedField, equals: .password)
                    }
                    
                    loginButton(viewStore)
                    
                    separator
                    
                    Text(#localized("Forgot Password"))
                        .font(.customSubHeadline)
                        .foregroundStyle(#color("secondary"))
                        .onTapGesture {
                            viewStore.send(.forgotPasswordButtonTapped)
                        }
                }
                .padding(30)
                .background(.regularMaterial)
                .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(color: #color("shadow").opacity(0.3), radius: 5, x: 0, y: 3)
                .shadow(color: #color("shadow").opacity(0.3), radius: 30, x: 0, y: 30)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(.linearGradient(colors: [.white.opacity(0.8), .white.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing))
                )
                .padding()
                .bind(viewStore.$focusedField, to: self.$focusedField)
            }
            .background(background)
        }
    }
}

// MARK: Views Parts
extension LoginView {
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
    
    private func loginButton(_ viewStore: ViewStoreOf<Login>) -> some View {
        Button {
            viewStore.send(.loginButtonTapped)
        } label: {
            HStack {
                Image(systemName: "arrow.right")
                Text(#localized("Login"))
                    .font(.customHeadline)
            }
            .largeButton()
        }
    }
}

#Preview {
    LoginView(
        store: .init(
            initialState: .init(),
            reducer: Login.init
        )
    )
}
