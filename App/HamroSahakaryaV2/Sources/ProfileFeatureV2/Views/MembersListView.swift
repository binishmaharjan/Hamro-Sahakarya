import SwiftUI
import ComposableArchitecture
import SharedUIs
import SharedModels

public struct MembersListView: View {
    public init(store: StoreOf<MembersList>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<MembersList>
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(store.members) { member in
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
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background(#color("white"))
                    .mask(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .padding(.horizontal, 20)
                }
            }
            .padding(.top, 16)
        }
        .customNavigationBar("Members")
        .background(#color("background"))
        .loadingView(store.isLoading)
        .onAppear { store.send(.onAppear) }
        .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
    }
}

#Preview {
    MembersListView(
        store: .init(
            initialState: .init(members: [.mock, .mock, .mock]),
            reducer: MembersList.init
        )
    )
}
