import SwiftUI
import SharedModels
import SharedUIs
import SwiftHelpers

struct GroupDetailCardView: View {
    init(homeResponse: HomeResponse?) {
        self.homeResponse = homeResponse
    }
    
    var homeResponse: HomeResponse?
    
    var body: some View {
        VStack(spacing: 0) {
            
            Text(#localized("Group Detail"))
                .font(.customFootnote2)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
            
            HStack {
                CardItemView(
                    type: .large,
                    title: #localized("Current Balance"),
                    value: (homeResponse?.currentBalance).safeUnwrap.jaCurrency
                )
                
                CardItemView(
                    type: .large,
                    title: #localized("Loan Given"),
                    value: (homeResponse?.loanGiven).safeUnwrap.jaCurrency
                )
            }
            .frame(maxWidth: .infinity)
            
            
            Color.clear.frame(height: 2)
            
            HStack {
                CardItemView(
                    type: .small,
                    title: #localized("Total Balance"),
                    value: (homeResponse?.totalBalance).safeUnwrap.jaCurrency
                )
                
                CardItemView(
                    type: .small,
                    title: #localized("Profit"),
                    value: (homeResponse?.profit).safeUnwrap.jaCurrency
                )
            }
            .frame(maxWidth: .infinity)
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 24)
        .padding(.bottom, 28)
        .padding(.top, 16)
        .background(
            #img("img_background2")
                .blur(radius: 40)
        )
        .mask {
            RoundedRectangle(cornerRadius: 8)
        }
    }
}

#Preview {
    GroupDetailCardView(homeResponse: .mock)
}
