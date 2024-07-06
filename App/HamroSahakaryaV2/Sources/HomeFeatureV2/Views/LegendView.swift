import SwiftUI
import SharedUIs
import SharedModels

struct LegendView: View {
    enum `Type` {
        case title
        case row
    }
    
    var type: Type
    var member: User = .mock
    var isUser: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 2) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(
                        type == .title
                        ? .clear
                        : isUser ? #color("white") : Color(hex: member.colorHex)
                    )
                    .frame(width: 20)
                
                Spacer()
                    .frame(width: 4)
                
                Text(type == .title ? #localized("Member") : member.username)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                
                Text(type == .title ? #localized("Balance") : member.balance.jaCurrency)
                    .frame(width: geometry.size.width / 4, height: 20, alignment: .trailing)
                
                Text(type == .title ? #localized("Loan") : member.loanTaken.jaCurrency)
                    .frame(width: geometry.size.width / 4, height: 20, alignment: .trailing)
                    
            }
            .padding(.vertical, 2)
            .padding(.horizontal, 6)
            .frame(maxWidth: .infinity)
            .font(type == .title ? .customSubHeadline2 : .customCaption2)
            .foregroundColor(
                type == .title
                ? #color("large_button")
                : isUser ? #color("white") : #color("black")
            )
            .background(
                RoundedRectangle(cornerRadius: 2)
                    .fill(isUser ? Color(hex: member.colorHex) : Color.clear)
            )
        }
        .frame(height: 24)
    }
}
