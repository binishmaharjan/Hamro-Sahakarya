import SwiftUI
import SharedUIs
import SharedModels

struct MemberSelectItemView: View {
    var member: User
    var isSelected: Bool
    var onTapped: (() -> Void)?
    
    var body: some View {
        Button {
            onTapped?()
        } label: {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    BorderedImageView(urlString: member.iconUrl)
                        .frame(width: 44, height: 44)
                        .padding(8)
                    
                    Text(member.username)
                        .minimumScaleFactor(0.5)
                        .font(.customHeadline)
                        .foregroundStyle(#color("large_button"))
                        .padding(.leading, 8)
                    
                    Spacer()
                    
                    if isSelected {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.customTitle3)
                            .foregroundStyle(#color("large_button"))
                            .padding(.trailing, 16)
                    }
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
    MemberSelectItemView(member: .mock, isSelected: true)
}
