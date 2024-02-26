import SwiftUI
import ComposableArchitecture
import SharedUIs

public struct AddMonthlyFeeView: View {
    public init(store: StoreOf<AddMonthlyFee>) {
        self.store = store
    }
    
    @FocusState private var focusedField: AddMonthlyFee.State.Field?
    @Bindable private var store: StoreOf<AddMonthlyFee>
    
    public var body: some View {
        VStack(spacing: 24) {
            VStack(alignment: .leading) {
                Text(#localized("Amount"))
                    .font(.customSubHeadline)
                    .foregroundStyle(#color("secondary"))
                
                TextField(#localized("Amount"), text: $store.amount)
                    .textFieldStyle(.icon(#img("icon_yen")))
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .amount)
            }
            VStack {
                Text(#localized("Select Target Members"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.customSubHeadline2)
                    .foregroundStyle(#color("gray"))
                
                MemberSelectView(store: store.scope(state: \.memberSelect, action: \.memberSelect))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            addMonthlyFeeButton
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(20)
        .padding()
        .bind($store.focusedField, to: self.$focusedField)
        .background(#color("background"))
        .customNavigationBar(#localized("Add Monthly Fee"))
        .loadingView(store.isLoading)
        .onAppear { store.send(.onAppear) }
        .alert(
            $store.scope(state: \.destination?.alert, action: \.destination.alert)
        )
    }
}

// MARK: View Parts
extension AddMonthlyFeeView {
    private var addMonthlyFeeButton: some View {
        Button {
            store.send(.addMonthlyFeeTapped)
        } label: {
            HStack {
                Image(systemName: "arrow.right")
                Text(#localized("Add Monthly Fee"))
                    .font(.customHeadline)
            }
            .largeButton()
        }
        .disabled(!store.isValidInput)
    }
}

#Preview {
    AddMonthlyFeeView(
        store: .init(
            initialState: .init(members: [.mock ,.mock2]),
            reducer: AddMonthlyFee.init
        )
    )
}
