import SwiftUI
import SharedModels
import SharedUIs
import ComposableArchitecture

public struct NoticeView: View {
    public init(store: StoreOf<Notice>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<Notice>
    
    public var body: some View {
        VStack {
            Text("Notice")
                .font(.customTitle2)
                .padding()
            
            Text(store.notice.message)
            
            Text(store.notice.dateCreated.toDate(for: .dateTime).toString(for: .monthDateYear))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.top, 8)
            
            Text(store.notice.admin)
                .frame(maxWidth: .infinity, alignment: .trailing)
            Button {
                store.send(.okButtonTapped)
            } label: {
                HStack {
                    Image(systemName: "arrow.right")
                    Text(#localized("Got it!"))
                        .font(.customHeadline)
                }
                .largeButton()
            }
            .padding()
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding()
        .background(#color("background"))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .shadow(color: #color("background2").opacity(0.1), radius: 10, x: 0, y: 1)
        .padding(30)
    }
}

#Preview {
    NoticeView(
        store: .init(
            initialState: .init(notice: .mock),
            reducer: Notice.init
        )
    )
}
