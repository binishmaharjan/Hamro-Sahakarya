import SwiftUI

public struct BorderedImageView: View {
    public init(urlString: String?, borderColor: Color = #color("large_button").opacity(0.5)) {
        self.urlString = urlString
        self.borderColor = borderColor
    }
    
    private var urlString: String?
    private var borderColor: Color
    
    public var body: some View {
        if let urlString, let url = URL(string: urlString) {
            AsyncImage(url: url) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Color.clear
                        .background(.ultraThinMaterial)
                }
            }
            .clipShape(Circle())
            .overlay {
                Circle()
                    .stroke(borderColor, lineWidth: 5)
            }
        } else {
            Color.clear
                .background(.ultraThinMaterial)
                .clipShape(Circle())
                .overlay {
                    Circle()
                        .stroke(borderColor, lineWidth: 5)
                }
        }
    }
}

#Preview {
    BorderedImageView(urlString: "")
}
