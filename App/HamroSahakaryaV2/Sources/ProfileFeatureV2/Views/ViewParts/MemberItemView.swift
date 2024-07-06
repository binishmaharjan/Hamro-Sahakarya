import SwiftUI
import SharedUIs
import SharedModels

struct MemberItemView: View {
    var member: User
    var body: some View {
        HStack(spacing: 16) {
            BorderedImageView(urlString: member.iconUrl)
                .frame(width: 60, height: 60)
                .padding(.leading, 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(member.username)
                    .font(.customHeadline)
                    .foregroundStyle(#color("large_button"))
                
                Text("Current Status: " + member.status.rawValue)
                    .font(.customFootnote)
                    .foregroundStyle(#color("gray"))
                
                Text("Member Since: " + member.dateCreated.toDate(for: .dateTime).formatted(.yearMonthDate))
                    .font(.customFootnote)
                    .foregroundStyle(#color("gray"))
                
//                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    MemberItemView(member: .mock)
}
