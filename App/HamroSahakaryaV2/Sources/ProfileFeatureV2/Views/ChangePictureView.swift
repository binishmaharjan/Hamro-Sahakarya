import SwiftUI
import ComposableArchitecture
import SharedUIs
import PhotosService
import UIKit

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
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                saveButton
            }
        }
        .loadingView(store.isLoading)
        .alert(
            $store.scope(state: \.destination?.alert, action: \.destination.alert)
        )
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

    private var saveButton: some View {
        Button {
            Task { @MainActor in
               store.send(.saveButtonTapped(renderImage()))
            }
        } label: {
            Text(#localized("Save"))
                .font(.customSubHeadline2)
                .foregroundStyle(store.isButtonEnabled ? #color("large_button") : #color("large_button").opacity(0.5))
        }
        .disabled(!store.isButtonEnabled)
    }

    @MainActor private func renderImage() -> UIImage {
        let renderer = ImageRenderer(content: imagePreview(for: store.imageData))
        guard let uiImage = renderer.uiImage else {
            return UIImage()
        }
        return uiImage
    }
}

#Preview {
    ChangePictureView(
        store: .init(
            initialState: .init(user: .mock),
            reducer: ChangePicture.init
        )
    )
}
