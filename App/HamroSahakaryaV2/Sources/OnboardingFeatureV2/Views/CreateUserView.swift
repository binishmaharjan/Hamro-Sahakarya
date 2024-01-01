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
                            
                            TextField(#localized("Email"), text: viewStore.$email)
                                .textFieldStyle(.icon(#img("icon_email")))
                        }
                        
                        VStack(alignment: .leading) {
                            Text(#localized("Fullname"))
                                .font(.customSubHeadline)
                                .foregroundStyle(#color("secondary"))
                            
                            TextField(#localized("Fullname"), text: viewStore.$fullname)
                                .textFieldStyle(.icon(#img("icon_person")))
                        }
                        
                        VStack(alignment: .leading) {
                            Text(#localized("Password"))
                                .font(.customSubHeadline)
                                .foregroundStyle(#color("secondary"))
                            
                            TextField(#localized("Password"), text: viewStore.$password)
                                .textFieldStyle(.icon(#img("icon_lock")))
                        }
                        
                        VStack(alignment: .leading) {
                            Text(#localized("Status"))
                                .font(.customSubHeadline)
                                .foregroundStyle(#color("secondary"))
                            
                            TextField(#localized("Status"), text: .constant(viewStore.status.rawValue))
                                .textFieldStyle(.tapOnly(#img("icon_admin")) {
                                    viewStore.send(.memberFieldTapped)
                                })
                        }
                        
                        VStack(alignment: .leading) {
                            Text(#localized("Color"))
                                .font(.customSubHeadline)
                                .foregroundStyle(#color("secondary"))
                            
                            TextField("", text: .constant(""))
                                .textFieldStyle(
                                    .colorPicker(#img("icon_palatte"), colorHex: viewStore.colorHex) {
                                        viewStore.send(.colorPickerFieldTapped)
                                    }
                                )
                        }
                        
                        VStack(alignment: .leading) {
                            Text(#localized("Initial Amount"))
                                .font(.customSubHeadline)
                                .foregroundStyle(#color("secondary"))
                            
                            TextField(#localized("Initial Amount"), text: viewStore.$initialAmount)
                                .textFieldStyle(.icon(#img("icon_yen")))
                        }
                        
                        createUserButton(viewStore)
                    }
                    .padding(30)
                    .padding()
                }
                .navigationBarHidden(true)
                .splineBackground()
                .dismissKeyboardOnTap()
                .ignoresSafeArea()
                
                closeButton
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(20)
            }
            .loadingView(viewStore.isLoading)
            .confirmationDialog(
                store: store.scope(state: \.$destination.confirmationDialog, action: \.destination.confirmationDialog)
            )
            .fullScreenCover(store: store.scope(state: \.$destination.colorPicker, action: \.destination.colorPicker)) { store in
                ColorPickerView(store: store)
                    .presentationBackground(#color("secondary"))
            }
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
    
    private func createUserButton(_ viewStore: ViewStoreOf<CreateUser>) -> some View {
        Button {
            viewStore.send(.createUserButtonTapped)
        } label: {
            HStack {
                Image(systemName: "arrow.right")
                Text(#localized("Create User"))
                    .font(.customHeadline)
            }
            .largeButton()
        }
        .disabled(!viewStore.isValidInput)
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
