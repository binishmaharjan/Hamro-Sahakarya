import SwiftUI
import SharedModels
import SharedUIs

struct MyDetailCardView: View {
    init(user: User) {
        self.user = user
    }
    
    var user: User
    
    var body: some View {
        VStack(spacing: 0) {
            
            Text(#localized("My Detail"))
                .font(.customFootnote2)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
            
            CardItemView(
                type: .large,
                title: #localized("Balance"),
                value: user.balance.jaCurrency
            )
            
            Color.clear.frame(height: 2)
            
            CardItemView(
                type: .small,
                title: #localized("Loan"),
                value: user.loanTaken.jaCurrency
            )
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
    MyDetailCardView(user: .mock)
}
