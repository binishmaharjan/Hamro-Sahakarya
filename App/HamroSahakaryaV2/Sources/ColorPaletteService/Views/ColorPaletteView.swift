import SwiftUI
import ComposableArchitecture
import SharedUIs

public struct ColorPaletteView: View {
    public init(store: StoreOf<ColorPalette>) {
        self.store = store
    }
    
    private let store: StoreOf<ColorPalette>
    
    public var body: some View {
        ColorPaletteRepresentable { color in
            if let colorHex = color.toHexString() {
                store.send(.viewTappedOn(colorHex))
            }
        }
        .border(#color("gray"))
    }
}

#Preview {
    ColorPaletteView(
        store: .init(
            initialState: .init(),
            reducer: ColorPalette.init
        )
    )
}

