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
                ColorPaletteView(store: store.scope(state: \.colorPalette, action: \.colorPalette))
                    .aspectRatio(1, contentMode: .fit)
                
                HStack {
                    Rectangle()
                        .fill(Color(hex: viewStore.state.colorHex))
                        .frame(maxWidth: .infinity)
                    
                    Text(viewStore.state.colorHex)
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
                closeButton(viewStore)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .offset(x: 18, y: -18)
            )
            .padding(.horizontal, 32)
        }
    }
}

// MARK: Views Parts
extension ColorPickerView {
    
    private func closeButton(_ viewStore: ViewStoreOf<ColorPicker>) -> some View {
        Button {
            viewStore.send(.closeButtonTapped)
        } label: {
            Image(systemName: "xmark")
                .frame(width: 36, height: 36)
                .foregroundColor(#color("white"))
                .background(#color("black"))
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
                Text(#localized("Select Color"))
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
