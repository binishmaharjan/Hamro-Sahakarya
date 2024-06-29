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
            
            Text(#localized("Balance"))
                .font(.customFootnote)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
            
            Text(user.balance.jaCurrency)
                .font(.customTitle)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
            
            Color.clear.frame(height: 2)
            
            Text(#localized("Loan"))
                .font(.customFootnote)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
            
            Text(user.loanTaken.jaCurrency)
                .font(.customSubHeadline2)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
            
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
