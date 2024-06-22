import SwiftUI

public struct SplineBackground: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .frame(maxHeight: .infinity)
            .background(.ultraThinMaterial)
            .background(
                #img("img_spline")
                    .blur(radius: 60)
                    .offset(x: 200, y: 100)
            )
    }
}

extension View {
    public func splineBackground() -> some View {
        modifier(SplineBackground())
    }
}

public struct BluredSakuraBackground: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .frame(maxHeight: .infinity)
            .background(
                #img("img_background2")
                    .blur(radius: 80)
            )
    }
}

extension View {
    public func bluredSakuraBackground() -> some View {
        modifier(BluredSakuraBackground())
    }
}
