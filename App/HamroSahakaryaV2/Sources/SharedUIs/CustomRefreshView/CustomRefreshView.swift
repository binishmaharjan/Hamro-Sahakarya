import SwiftUI

private enum Configuration {
    static var maxScrollOffset: CGFloat = 75
    static var scrollCoordinateSpace: String = UUID().uuidString
}

public struct CustomRefreshView<Content: View>: View {
    public init(
        scrollDelegate: ScrollViewModel,
        showIndicator: Bool = false,
        navigationHeight: CGFloat = 0,
        @ViewBuilder content: @escaping () -> Content,
        onRefresh: @escaping () async -> Void
    ) {
        self.content = content()
        self.scrollDelegate = scrollDelegate
        self.showIndicator = showIndicator
        self.navigationHeight = navigationHeight
        self.onRefresh = onRefresh
    }
    
    // MARK: Properties
    private var content: Content
    private var scrollDelegate: ScrollViewModel
    private var showIndicator: Bool
    private var navigationHeight: CGFloat
    private var onRefresh: () async -> Void
    
    // MARK: Body
    public var body: some View {
        ScrollView(.vertical, showsIndicators: showIndicator) {
            VStack(spacing: 0) {
                content
                    .offset(y: Configuration.maxScrollOffset * scrollDelegate.progress)
            }
            .overlay {
                VStack(spacing: 0) {
                    // MARK: Adding a clear frame to avoid space from Custom Navigation Bar
                    Color.clear.frame(height: navigationHeight)
                    
                    progressView
                    .scaleEffect(scrollDelegate.isEligible ? 1 : 0.001)
                    .animation(.easeInOut(duration: 0.25), value: scrollDelegate.isEligible)
                    .overlay {
                        arrowAndText
                        .opacity(scrollDelegate.isEligible ? 0 : 1)
                        .animation(.easeInOut(duration: 0.25), value: scrollDelegate.isEligible)
                    }
                    .frame(height: Configuration.maxScrollOffset * scrollDelegate.progress)
                    .frame(maxWidth: .infinity)
                    .opacity(scrollDelegate.progress)
                    .offset(
                        y: scrollDelegate.isEligible
                        ? -(scrollDelegate.contentOffset < 0 ? 0 : scrollDelegate.contentOffset)
                        : -(scrollDelegate.scrollOffset < 0 ? 0 : scrollDelegate.scrollOffset)
                    )
                    
                    Spacer()
                }
                .ignoresSafeArea(.all)
            }
            .offset(coordinateSpace: Configuration.scrollCoordinateSpace) { offset in
                // MARK: Storing Content Offset
                scrollDelegate.contentOffset = offset
                
                // MARK: Stopping the progress when its eligible for refresh
                if !scrollDelegate.isEligible  {
                    var progress = offset / Configuration.maxScrollOffset
                    progress = (progress < 0 ? 0 : progress)
                    progress = (progress > 1 ? 1 : progress)
                    scrollDelegate.scrollOffset = offset
                    scrollDelegate.progress = progress
                }
                
                if scrollDelegate.isEligible && !scrollDelegate.isRefreshing {
                    scrollDelegate.isRefreshing = true
                    // MARK: haptic Feedback
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }
            }
        }
        .coordinateSpace(name: Configuration.scrollCoordinateSpace)
        .onAppear(perform: scrollDelegate.addGesture)
        .onDisappear(perform: scrollDelegate.removeGesture)
        .onChange(of: scrollDelegate.isRefreshing) { _, newValue in
            // MARK: Calling Async Method
            if newValue {
                Task {
                    await onRefresh()
                    // MARK: After Refresh, resetting the properties
                    withAnimation(.easeInOut(duration: 0.25)) {
                        scrollDelegate.progress = 0
                        scrollDelegate.isEligible = false
                        scrollDelegate.isRefreshing = false
                        scrollDelegate.scrollOffset = 0
                    }
                }
            }
        }
    }
}

// MARK: View Parts
extension CustomRefreshView {
    private var progressView: some View {
        VStack {
            ProgressView()
                .tint(#color("large_button"))
            
            Text("Fetching Data..")
                .font(.caption.bold())
        }
        .foregroundStyle(#color("large_button"))
    }
    
    private var arrowAndText: some View {
        VStack(spacing: 12) {
            Image(systemName: "arrow.down")
                .font(.caption.bold())
                .foregroundStyle(Color.white)
                .rotationEffect(.init(degrees: scrollDelegate.progress * 180))
                .padding(8)
                .background(#color("large_button"), in: Circle())
            
            Text("Pull To Refresh")
                .font(.caption.bold())
                .foregroundStyle(#color("large_button"))
        }
    }
}

// MARK: Offset Modifier
extension View {
    @ViewBuilder
    public func offset(coordinateSpace: String, offset: @escaping (CGFloat) -> Void) -> some View {
        self.overlay {
            GeometryReader { proxy in
                let minY = proxy.frame(in: .named(coordinateSpace)).minY
                Color.clear
                    .preference(key: OffsetKey.self, value: minY)
                    .onPreferenceChange(OffsetKey.self) { value in
                        offset(value)
                    }
            }
        }
    }
}

// MARK: Offset Preference Key
struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: For Simultaneous Pan Gesture
@Observable
final public class ScrollViewModel: NSObject, UIGestureRecognizerDelegate {
    // MARK: Properties
    var isEligible: Bool = false
    var isRefreshing: Bool = false
    // MARK: Offset And Progress
    var scrollOffset: CGFloat = 0
    var contentOffset: CGFloat = 0
    var progress: CGFloat = 0
    let gestureID = UUID().uuidString
    
    // MARK: Since we need to know when user left the screen to start refresh
    // Adding pan gesture to ui main application window
    // with Simultaneous Gesture
    // Thus it wont disturb the SwiftUI scroll and gesture
    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }
    
    // MARK: Adding gesture
    func addGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onGestureChanged(gesture:)))
        panGesture.delegate = self
        panGesture.name = gestureID
        rootViewController().view.addGestureRecognizer(panGesture)
    }
    
    // MARK: Removing Gesture When Leaving the view
    func removeGesture() {
        rootViewController().view.gestureRecognizers?.removeAll(where: { gesture in
            gesture.name == gestureID
        })
    }
    
    // MARK: Root View
    func rootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return UIViewController()
        }
        
        guard let rootView = screen.windows.first?.rootViewController else {
            return UIViewController()
        }
        
        return rootView
    }
    
    @objc func onGestureChanged(gesture: UIPanGestureRecognizer) {
        if gesture.state == .cancelled || gesture.state == .ended {
            // MARK: Max Scroll Offset
            if !isRefreshing {
                if scrollOffset > 75 {
                    isEligible = true
                } else {
                    isEligible = false
                }
            }
        }
    }
}

#Preview {
    var previewScrollDelegate = ScrollViewModel()
    return CustomRefreshView(scrollDelegate: previewScrollDelegate, showIndicator: false) {
        Rectangle()
            .fill(.clear)
            .background(.ultraThinMaterial)
            .frame(height: 200)
    } onRefresh: {
        try! await Task.sleep(nanoseconds: 3_000_000_000)
    }
}
