import SwiftUI
import ComposableArchitecture
import SharedUIs

public struct CreateUserView: View {
    public init(store: StoreOf<CreateUser>) {
        self.store = store
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Bindable private var store: StoreOf<CreateUser>
    
    public var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 24) {
                    Text(#localized("Create User"))
                        .font(.customLargeTitle)
                        .lineLimit(1)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    VStack(alignment: .leading) {
                        Text(#localized("Email"))
                            .font(.customSubHeadline)
                            .foregroundStyle(#color("secondary"))
                        
                        TextField(#localized("Email"), text: $store.email)
                            .textFieldStyle(.icon(#img("icon_email")))
                            .keyboardType(.emailAddress)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(#localized("Fullname"))
                            .font(.customSubHeadline)
                            .foregroundStyle(#color("secondary"))
                        
                        TextField(#localized("Fullname"), text: $store.fullname)
                            .textFieldStyle(.icon(#img("icon_person")))
                    }
                    
                    VStack(alignment: .leading) {
                        Text(#localized("Password"))
                            .font(.customSubHeadline)
                            .foregroundStyle(#color("secondary"))
                        
                        TextField(#localized("Password"), text: $store.password)
                            .textFieldStyle(.icon(#img("icon_lock")))
                    }
                    
                    VStack(alignment: .leading) {
                        Text(#localized("Status"))
                            .font(.customSubHeadline)
                            .foregroundStyle(#color("secondary"))
                        
                        TextField(#localized("Status"), text: .constant(store.status.rawValue))
                            .textFieldStyle(.tapOnly(#img("icon_admin")) {
                                store.send(.memberFieldTapped)
                            })
                    }
                    
                    VStack(alignment: .leading) {
                        Text(#localized("Color"))
                            .font(.customSubHeadline)
                            .foregroundStyle(#color("secondary"))
                        
                        TextField("", text: .constant(""))
                            .textFieldStyle(
                                .colorPicker(#img("icon_palatte"), colorHex: store.colorHex) {
                                    store.send(.colorPickerFieldTapped)
                                }
                            )
                    }
                    
                    VStack(alignment: .leading) {
                        Text(#localized("Initial Amount"))
                            .font(.customSubHeadline)
                            .foregroundStyle(#color("secondary"))
                        
                        TextField(#localized("Initial Amount"), text: $store.initialAmount)
                            .textFieldStyle(.icon(#img("icon_yen")))
                            .keyboardType(.numberPad)
                    }
                    
                    createUserButton
                }
                .padding(30)
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarHidden(true)
            .dismissKeyboardOnTap()
            
            closeButton
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(20)
        }
        .splineBackground()
        .loadingView(store.isLoading)
        .confirmationDialog(
            $store.scope(state: \.destination?.confirmationDialog, action: \.destination.confirmationDialog)
        )
        .fullScreenCover(
            item: $store.scope(state: \.destination?.colorPicker, action: \.destination.colorPicker)
        ) { store in
            ColorPickerView(store: store)
                .presentationBackground(Color.clear)
        }
        .alert(
            $store.scope(state: \.destination?.alert, action: \.destination.alert)
        )
    }
}

// MARK: Views Parts
extension CreateUserView {
//    private var background: some View {
//        #img("img_spline")
//            .blur(radius: 60)
//            .offset(x: 200, y: 100)
//    }
    
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
    
    private var createUserButton: some View {
        Button {
            store.send(.createUserButtonTapped)
        } label: {
            HStack {
                Image(systemName: "arrow.right")
                Text(#localized("Create User"))
                    .font(.customHeadline)
            }
            .largeButton()
        }
        .disabled(!store.isValidInput)
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
