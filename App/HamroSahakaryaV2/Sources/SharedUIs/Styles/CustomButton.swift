import SwiftUI

// MARK: Highlight Button
public struct HighlightButtonStyle: ButtonStyle {
    @ViewBuilder
    public func makeBody(configuration: Configuration) -> some View {
        let backgroundColor = #color("white")
        let pressedColor = #color("gray").opacity(0.5)
        let background = configuration.isPressed ? pressedColor : backgroundColor
        
        configuration.label
            .foregroundColor(.white)
            .background(background)
            .cornerRadius(8)
    }
}

extension ButtonStyle where Self == HighlightButtonStyle {
    public static var highlight: HighlightButtonStyle {
        return HighlightButtonStyle()
    }
}
