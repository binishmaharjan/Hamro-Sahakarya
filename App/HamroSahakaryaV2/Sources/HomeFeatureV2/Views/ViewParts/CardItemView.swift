import SwiftUI

struct CardItemView: View {
    enum `Type` {
        case large
        case small
    }
    
    init(type: Type, title: String, value: String) {
        self.type = type
        self.title = title
        self.value = value
    }
    
    var type: Type
    var title: String
    var value: String
    
    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .font(.customFootnote)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
            
            Text(value)
                .minimumScaleFactor(0.5)
                .font(type == .large ? .customTitle : .customSubHeadline2)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
        }
    }
}
