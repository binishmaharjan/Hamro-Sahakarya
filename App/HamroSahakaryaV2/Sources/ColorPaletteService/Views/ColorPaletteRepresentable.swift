import UIKit
import SwiftUI

public struct ColorPaletteRepresentable: UIViewRepresentable {
    public var onColorSelected: ((Color) -> Void)?
    
    public func makeUIView(context: Context) -> ColorPaletteUIView {
        let colorPickerView = ColorPaletteUIView()
        colorPickerView.onColorDidChange = { color in
            self.onColorSelected?(Color(uiColor: color))
        }
        return colorPickerView
    }
    
    public func updateUIView(_ uiView: ColorPaletteUIView, context: Context) {
        // Update UI if needed
    }
}
