import SwiftUI
import ComposableArchitecture
import SharedUIs
import PhotosService

public struct ChangePictureView: View {
    public init(store: StoreOf<ChangePicture>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<ChangePicture>
    
    public var body: some View {
        VStack {
            VStack {
                imagePreview(for: store.imageData)
            }
            .frame(width: 300, height: 300)
            .background(Color.red.opacity(0.3))
            .padding(.top, 8)
            
            PhotoPickerView(
                store: store.scope(
                    state: \.photoPicker,
                    action: \.photoPicker
                )
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(#color("background"))
        .customNavigationBar(#localized("Change Picture"))
    }
}

// Views
extension ChangePictureView {
    private func imagePreview(for imageData: Data?) -> some View {
        guard let imageData, let image = Image(from: imageData) else { return AnyView(EmptyView()) }
        return AnyView(
            image
                .resizable()
                .frame(width: 300, height: 300)
                .aspectRatio(contentMode: .fill)
        )
    }
    private var updateButton: some View {
        Button {
//            store.send(.updateButtonTapped)
        } label: {
            HStack {
                Image(systemName: "arrow.right")
                Text(#localized("Change Password"))
                    .font(.customHeadline)
            }
            .largeButton()
        }
    }
}

#Preview {
    ChangePictureView(
        store: .init(
            initialState: .init(),
            reducer: ChangePicture.init
        )
    )
}
