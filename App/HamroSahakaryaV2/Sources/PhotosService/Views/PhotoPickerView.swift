import SwiftUI
import ComposableArchitecture
import SharedUIs

public struct PhotoPickerView: View {
    public init(store: StoreOf<PhotoPicker>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<PhotoPicker>
    private let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 0), count: 4)
    
    public var body: some View {
        VStack {
            // When Authorized and has image in Photos
            if store.authorizationStatus.isAuthorized, store.assets.count > 0 {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 0) {
                        ForEach(0 ..< store.assets.count, id: \.self) { index in
                            Button {
                                store.send(.imageSelected(at: index))
                            } label: {
                                imageItem(for: index)
                                    .selectedBorder(for: store.selectedImageIndex == index)
                            }
                        }
                    }
                }
            } 
            // When Authorized but has no image in Photos
            else if store.authorizationStatus.isAuthorized, store.assets.count == 0 {
                Text(#localized("No image found in Photos."))
                    .multilineTextAlignment(.center)
                    .font(.customCaption)
                    .padding()
            }
            // Not Authorized
            else if store.authorizationStatus.isNotAuthorized {
                VStack {
                    Text(#localized("No access to photos. Please turn on the access from the settings app."))
                        .multilineTextAlignment(.center)
                        .font(.customCaption)
                        .padding()
                    
                    openSettingsButton
                }
                .padding(20)
                .frame(maxHeight: .infinity)
            }
        }
        .onAppear { store.send(.onAppear) }
    }
}

// MARK: View Parts
extension PhotoPickerView {
    private var openSettingsButton: some View {
        Button {
            store.send(.openSettingsButtonTapped)
        } label: {
            HStack {
                Text(#localized("Open Settings"))
                    .font(.customCaption2)
            }
            .smallButton()
        }
    }
    
    private func imageItem(for index: Int) -> some View {
        VStack {
            if let image = store.assets.fetchImage(imageType: .thumbnail, index: index) {
                image
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                
            } else {
                Image(systemName: "exclamationmark.bubble.circle")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .font(.largeTitle)
                    .foregroundStyle(#color("large_button"))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .aspectRatio(1, contentMode: .fit)
        .overlay {
            Rectangle().stroke(#color("background"), lineWidth: 1)
        }
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
