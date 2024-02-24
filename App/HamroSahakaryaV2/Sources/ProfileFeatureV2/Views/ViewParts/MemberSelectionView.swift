import SwiftUI
import SharedUIs

struct MemberSelectionItemView: View {
    var label: String
    var onTapped: (() -> Void)?
    
    var body: some View {
        Button {
            onTapped?()
        } label: {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    BorderedImageView(urlString: "")
                        .frame(width: 44, height: 44)
                        .padding(8)
                    
                    Text(label)
                        .font(.customHeadline)
                        .foregroundStyle(#color("large_button"))
                        .padding(.leading, 8)
                    
                    Spacer()
                }
                .padding(.leading, 8)
            }
            .padding(.vertical, 2)
            .mask(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .buttonStyle(.highlight)
    }
}

#Preview {
    MemberSelectionItemView(label: "Member One")
}
