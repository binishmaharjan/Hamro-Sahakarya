import SwiftUI

public struct PagingIndicator: View {
    public init(activeTintColor: Color, inactiveTintColor: Color) {
        self.activeTintColor = activeTintColor
        self.inactiveTintColor = inactiveTintColor
    }
    
    var activeTintColor: Color = .primary
    var inactiveTintColor: Color = .primary.opacity(0.5)
    
    public var body: some View {
        GeometryReader { geometry in
            // Entire View Size For Calculating Pages
            let width = geometry.size.width
            
            // Scroll View Bounds
            if let scrollViewWidth = geometry.bounds(of: .scrollView(axis: .horizontal))?.width, scrollViewWidth > 0 {
                let minX = geometry.frame(in: .scrollView(axis: .horizontal)).minX
                let totalPages = Int(width / scrollViewWidth)
                
                // Progress
                let progress = -minX / scrollViewWidth
                
                // Indexes
                let activeIndex = Int(progress)
                let nextIndex = Int(progress.rounded(.awayFromZero))
                let indicatorProgress = progress - CGFloat(activeIndex)
                
                // Indicator Width(Current And Upcomming)
                let currentPageWidth = 18 - (indicatorProgress * 18)
                let nextPageWidth = indicatorProgress * 18
                
                // Indicator View
                HStack(spacing: 10) {
                    ForEach(0..<totalPages, id: \.self) { index in
                        Capsule()
                            .fill(.clear)
                            .frame(
                                width: 8 + (
                                    activeIndex == index
                                    ? currentPageWidth
                                    : nextIndex == index ? nextPageWidth : 0
                                ),
                                height: 8
                            )
                            .overlay {
                                ZStack {
                                    Capsule()
                                        .fill(inactiveTintColor)
                                    
                                    Capsule()
                                        .fill(activeTintColor)
                                        .opacity(
                                            activeIndex == index
                                            ? 1 - indicatorProgress
                                            : nextIndex == index ? indicatorProgress : 0
                                        )
                                }
                            }
                    }
                }
                .frame(width: scrollViewWidth)
                .offset(x: -minX)
            }
        }
        .frame(height: 30)
    }
}

// MARK: Modifier
public struct PagingIndicatorModifier: ViewModifier {
    public init(activeTintColor: Color = .primary, inactiveTintColor: Color = .primary.opacity(0.5)) {
        self.activeTintColor = activeTintColor
        self.inactiveTintColor = inactiveTintColor
    }
    
    var activeTintColor: Color
    var inactiveTintColor: Color
    
    public func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                PagingIndicator(
                    activeTintColor: activeTintColor,
                    inactiveTintColor: inactiveTintColor
                )
            }
    }
}

extension View {
    public func defaultPagingIndicator() -> some View {
        modifier(PagingIndicatorModifier(activeTintColor: .white, inactiveTintColor: .white.opacity(0.5)))
    }
}
