import SwiftUI

public struct CustomButton: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .padding(16)
            .padding(.horizontal, 8)
            .background(.white)
            .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .foregroundStyle(.primary)
            .shadow(color: #color("black").opacity(0.3), radius: 20, x: 0, y: 10)
    }
}

extension View {
    public func customButton() -> some View {
        modifier(CustomButton())
    }
}

// MARK: Large Button
public struct LargeButton: ViewModifier {
    @Environment(\.isEnabled) var isEnabled
    
    public func body(content: Content) -> some View {
        content
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(isEnabled ? #color("large_button") : #color("large_button").opacity(0.5))
            .foregroundStyle(isEnabled ? #color("white") : #color("white").opacity(0.5))
            .mask(RoundedCorner(radius: 20, corners: [.topRight, .bottomLeft, .bottomRight]))
            .mask(RoundedRectangle(cornerRadius: 8))
            .shadow(color: #color("large_button").opacity(0.5), radius: 20, x: 0, y: 10)
    }
}

extension View {
    public func largeButton() -> some View {
        modifier(LargeButton())
    }
}

// MARK: Small Button
public struct SmallButton: ViewModifier {
    @Environment(\.isEnabled) var isEnabled
    
    public func body(content: Content) -> some View {
        content
            .padding(16)
            .background(isEnabled ? #color("large_button") : #color("large_button").opacity(0.5))
            .foregroundStyle(isEnabled ? #color("white") : #color("white").opacity(0.5))
            .mask(RoundedRectangle(cornerRadius: 16))
            .shadow(color: #color("large_button").opacity(0.5), radius: 20, x: 0, y: 10)
    }
}

extension View {
    public func smallButton() -> some View {
        modifier(SmallButton())
    }
}
