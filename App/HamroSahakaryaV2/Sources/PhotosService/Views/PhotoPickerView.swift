import SwiftUI
import ComposableArchitecture
import SharedUIs

public struct PhotoPickerView: View {
    public init(store: StoreOf<PhotoPicker>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<PhotoPicker>
    
    public var body: some View {
        VStack {
            if store.authorizationStatus.isAuthorized {
                
            } else if store.authorizationStatus.isNotAuthorized {
                Text(#localized("No access to photos. Please turn on the access from the settings app."))
                    .font(.customHeadline)
                    .padding()
            }
        }
        .onAppear { store.send(.onAppear) }
    }
}

#Preview {
    PhotoPickerView(
        store: .init(
            initialState: .init(),
            reducer: PhotoPicker.init
        )
    )
}
