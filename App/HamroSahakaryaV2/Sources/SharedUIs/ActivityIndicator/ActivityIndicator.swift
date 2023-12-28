import SwiftUI

// MARK: Activity Indicator
public struct ActivityIndicator: View {
    public init() { }
    
    @State private var currentDegrees = 0.0
    private let colorGradient = LinearGradient(
        gradient: Gradient(
            colors: [
                #color("green"),
                #color("green").opacity(0.75),
                #color("green").opacity(0.5),
                #color("green").opacity(0.2),
                .clear
            ]
        ),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    public var body: some View {
        Circle()
            .trim(from: 0.0, to: 0.85)
            .stroke(colorGradient, style: StrokeStyle(lineWidth: 5))
            .frame(width: 40, height: 40)
            .rotationEffect(Angle(degrees: currentDegrees))
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
                    withAnimation {
                        self.currentDegrees += 10
                    }
                }
            }
    }
}

#Preview {
    ActivityIndicator()
}

// MARK: View + Extension
extension View {
    public func loadingView(_ isLoading: Bool) -> some View {
        overlay {
            ZStack {
                if isLoading {
                    ActivityIndicator()
                }
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
            .allowsHitTesting(false)
        }
    }
}
