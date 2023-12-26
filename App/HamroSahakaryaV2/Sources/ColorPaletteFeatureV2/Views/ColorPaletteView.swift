import SwiftUI
import ComposableArchitecture
import SharedUIs

public struct ColorPaletteView: View {
    public init(store: StoreOf<ColorPalette>) {
        self.store = store
    }
    
    private let store: StoreOf<ColorPalette>
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ColorPaletteRepresentable { color in
                viewStore.send(.delegate(.colorSelected(color)))
            }
            .border(#color("gray"))
        }
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

