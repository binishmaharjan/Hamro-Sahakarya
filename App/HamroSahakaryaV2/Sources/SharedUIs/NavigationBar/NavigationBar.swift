import SwiftUI

public struct NavigationBar: View {
    public init(title: String) {
        self.title = title
    }
    
    public var title:String
    
    public var body: some View {
        ZStack {
            Color.clear
                .background(.ultraThinMaterial)
            
            Text(title)
                .foregroundStyle(#color("black"))
                .font(.system(size: 17, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .center)
        }
            .frame(height: 44)
            .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    NavigationBar(title: "Home")
}
