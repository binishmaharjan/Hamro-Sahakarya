import SwiftUI
import ComposableArchitecture
import SharedUIs

public struct CreateUserView: View {
    public init(store: StoreOf<CreateUser>) {
        self.store = store
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    private let store: StoreOf<CreateUser>
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ScrollView {
                ZStack {
                    
                    VStack(spacing: 24) {
                        Text(#localized("Create User"))
                            .font(.customLargeTitle)
                        
                        VStack(alignment: .leading) {
                            Text(#localized("Email"))
                                .font(.customSubHeadline)
                                .foregroundStyle(#color("secondary"))
                            
                            TextField("", text: .constant(""))
                                .customTextField(image: #img("icon_email"))
                            //                            .focused($focusedField, equals: .email)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(#localized("Fullname"))
                                .font(.customSubHeadline)
                                .foregroundStyle(#color("secondary"))
                            
                            TextField("", text: .constant(""))
                                .customTextField(image: #img("icon_person"))
                            //                            .focused($focusedField, equals: .email)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(#localized("Password"))
                                .font(.customSubHeadline)
                                .foregroundStyle(#color("secondary"))
                            
                            TextField("", text: .constant(""))
                                .customTextField(image: #img("icon_lock"))
                            //                            .focused($focusedField, equals: .email)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(#localized("Status"))
                                .font(.customSubHeadline)
                                .foregroundStyle(#color("secondary"))
                            
                            TextField("", text: .constant(""))
                                .customTextField(image: #img("icon_admin"))
                            //                            .focused($focusedField, equals: .email)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(#localized("Color"))
                                .font(.customSubHeadline)
                                .foregroundStyle(#color("secondary"))
                            
                            TextField("", text: .constant(""))
                                .customTextField(image: #img("icon_palatte"))
                            //                            .focused($focusedField, equals: .email)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(#localized("Initial Amount"))
                                .font(.customSubHeadline)
                                .foregroundStyle(#color("secondary"))
                            
                            TextField("", text: .constant(""))
                                .customTextField(image: #img("icon_yen"))
                            //                            .focused($focusedField, equals: .email)
                        }
                        
                        createUserButton(viewStore)
                    }
                    .padding(30)
                    .padding()
                    //                .bind(viewStore.$focusedField, to: self.$focusedField)
                    //                }
                    
                    Button {
                        // TODO: When @Dependency(\.dismiss) is used view is emptied when animation starts.
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
                .dismissKeyboardOnTap()
            }
            .ignoresSafeArea()
        }
    }
}

// MARK: Views Parts
extension CreateUserView {
    private var background: some View {
        #img("img_spline")
            .blur(radius: 60)
            .offset(x: 200, y: 100)
    }
    
    private func createUserButton(_ viewStore: ViewStoreOf<CreateUser>) -> some View {
        Button {
            //            viewStore.send(.forgotPasswordButtonTapped)
        } label: {
            HStack {
                Image(systemName: "arrow.right")
                Text(#localized("Create User"))
                    .font(.customHeadline)
            }
            .largeButton()
        }
        //        .disabled(!viewStore.isValidInput)
    }
}

#Preview {
    CreateUserView(
        store: .init(
            initialState: .init(),
            reducer: CreateUser.init
        )
    )
}
