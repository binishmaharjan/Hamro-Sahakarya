import SwiftUI

public struct BorderedImageView: View {
    public init(urlString: String?) {
        self.urlString = urlString
    }
    
    private var urlString: String?
    
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
                    .stroke(#color("large_button").opacity(0.5), lineWidth: 5)
            }
        } else {
            Color.clear
                .background(.ultraThinMaterial)
                .clipShape(Circle())
                .overlay {
                    Circle()
                        .stroke(#color("large_button").opacity(0.5), lineWidth: 5)
                }
        }
    }
}

#Preview {
    BorderedImageView(urlString: "")
}
