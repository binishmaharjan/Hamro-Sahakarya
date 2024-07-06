import SwiftUI

// MARK: Selected Border
public struct SelectionBorder: ViewModifier {
    public var isSelected: Bool
    public func body(content: Content) -> some View {
        content
            .overlay {
                Rectangle()
                    .strokeBorder(
                        isSelected ? #color("large_button") : .clear,
                        lineWidth: 5
                    )
            }
    }
}

extension View {
    public func selectedBorder(for isSelected: Bool) -> some View {
        modifier(SelectionBorder(isSelected: isSelected))
    }
}

