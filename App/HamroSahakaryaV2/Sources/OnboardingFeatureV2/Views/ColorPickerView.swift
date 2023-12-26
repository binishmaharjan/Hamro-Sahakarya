import SwiftUI
import ComposableArchitecture
import SharedUIs
import ColorPaletteFeatureV2

public struct ColorPickerView: View {
    public init(store: StoreOf<ColorPicker>) {
        self.store = store
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    private let store: StoreOf<ColorPicker>
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 24) {
                ColorPaletteView(
                    store: .init(
                        initialState: .init(),
                        reducer: ColorPalette.init
                    )
                )
                .aspectRatio(1, contentMode: .fit)
                
                HStack {
                    Rectangle().fill()
                        .frame(maxWidth: .infinity)
                    
                    Text("#000000")
                        .frame(maxWidth: .infinity)
                        .font(.title2)
                        .foregroundStyle(#color("secondary"))
                }
                .frame(height: 40)
                
                selectColorButton(viewStore)
                    .padding(.bottom, 8)
            }
            .padding(30)
            .background(.regularMaterial)
            .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: #color("shadow").opacity(0.3), radius: 5, x: 0, y: 3)
            .shadow(color: #color("shadow").opacity(0.3), radius: 30, x: 0, y: 30)
            .overlay(
                closeButton
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .offset(y: 16)
            )
        }
    }
}

// MARK: Views Parts
extension ColorPickerView {
    
    private var closeButton: some View {
        Button {
            // When @Dependency(\.dismiss) is used view is emptied when animation starts.
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "xmark")
                .frame(width: 36, height: 36)
                .foregroundColor(.black)
                .background(.white)
                .mask(Circle())
                .shadow(color: #color("shadow").opacity(0.3), radius: 5, x: 0, y: 3)
        }
    }
    
    private func selectColorButton(_ viewStore: ViewStoreOf<ColorPicker>) -> some View {
        Button {
            viewStore.send(.selectButtonTapped)
        } label: {
            HStack {
                Image(systemName: "arrow.right")
                Text(#localized("Create User"))
                    .font(.customHeadline)
            }
            .largeButton()
        }
    }
}

#Preview {
    ColorPickerView(
        store: .init(
            initialState: .init(),
            reducer: ColorPicker.init
        )
    )
}
