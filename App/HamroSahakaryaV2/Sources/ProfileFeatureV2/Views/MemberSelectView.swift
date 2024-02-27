import SwiftUI
import ComposableArchitecture
import SharedUIs

public struct MemberSelectView: View {
    public init(store: StoreOf<MemberSelect>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<MemberSelect>
    
    public var body: some View {
        ScrollView() {
            let isAllSelected = store.state.isAllMemberSelected()
            MemberSelectItemView(member: .allMember, isSelected: isAllSelected) {
                store.send(.rowSelected(.all))
            }
            
            separator
            
            VStack(spacing: 0) {
                ForEach(store.state.members) { member in
                    let isSelected = store.state.isSelected(member: member)
                    MemberSelectItemView(member: member, isSelected: isSelected) {
                        store.send(.rowSelected(.member(member)))
                    }
                }
            }
            .background(#color("white"))
            .mask(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
    }
}

// MARK: View Parts
extension MemberSelectView {
    private var separator: some View {
        HStack {
            Rectangle()
                .frame(height: 1)
                .opacity(0.1)
            
            Text(#localized("OR"))
                .font(.customSubHeadline2)
                .foregroundStyle(#color("black").opacity(0.3))
            
            Rectangle()
                .frame(height: 1)
                .opacity(0.1)
        }
    }
}

#Preview {
    MemberSelectView(
        store: .init(
            initialState: .init(members: [.mock, .mock2]),
            reducer: MemberSelect.init
        )
    )
}
