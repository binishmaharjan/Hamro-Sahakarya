import SwiftUI
import SharedUIs
import SharedModels

public struct LogItemView: View {
    public init(groupLog: GroupLog) {
        self.groupLog = groupLog
    }
    
    private var groupLog: GroupLog
    
    public var body: some View {
        VStack {
            HStack(spacing: 8) {
                groupLog.icon
                    .resizable()
                    .frame(width: 44, height: 44)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(groupLog.logTitle)
                        .font(.customHeadline)
                        .foregroundStyle(#color("large_button"))
                        .lineLimit(1)
                    
                    Text(groupLog.dateCreated.toDate(for: .dateTime).formatted(.logDate))
                        .font(.customFootnote)
                        .foregroundStyle(#color("gray"))
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            
            Divider()
                .overlay(#color("large_button"))
                .padding(.horizontal, 8)
            
            Text(groupLog.logDescription)
                .font(.customFootnote)
                .foregroundStyle(#color("black"))
                .padding(.horizontal, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity)
        .padding(8)
        .background(.white)
        .mask(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .shadow(color: #color("background2").opacity(0.1), radius: 10, x: 0, y: 1)
        .padding(.horizontal, 20)
    }
}

#Preview {
    Group {
        ScrollView {
            LogItemView(groupLog: .mockJoined)
            LogItemView(groupLog: .mockRemoved)
            LogItemView(groupLog: .mockLoanGiven)
            LogItemView(groupLog: .mockLoanReturned)
            LogItemView(groupLog: .mockMonthlyFee)
            LogItemView(groupLog: .mockExtra)
            LogItemView(groupLog: .mockExpenses)
            LogItemView(groupLog: .mockAddAmount)
            LogItemView(groupLog: .mockDeductAmount)
            LogItemView(groupLog: .mockMadeAdmin)
            LogItemView(groupLog: .mockRemovedAdmin)
        }
    }
}
