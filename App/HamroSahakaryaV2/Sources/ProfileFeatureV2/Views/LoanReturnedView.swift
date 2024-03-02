import SwiftUI
import ComposableArchitecture
import SharedUIs

public struct LoanReturnedView: View {
    public init(store: StoreOf<LoanReturned>) {
        self.store = store
    }
    
    @FocusState private var focusedField: LoanReturned.State.Field?
    @Bindable private var store: StoreOf<LoanReturned>
    
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
            
            addLoanMemberButton
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(20)
        .padding()
        .bind($store.focusedField, to: self.$focusedField)
        .background(#color("background"))
        .customNavigationBar(#localized("Loan Member"))
        .loadingView(store.isLoading)
        .onAppear { store.send(.onAppear) }
        .alert(
            $store.scope(state: \.destination?.alert, action: \.destination.alert)
        )
        
    }
}

// MARK: View Parts
extension LoanReturnedView {
    private var addLoanMemberButton: some View {
        Button {
            store.send(.loanReturnedTapped)
        } label: {
            HStack {
                Image(systemName: "arrow.right")
                Text(#localized("Loan Returned"))
                    .font(.customHeadline)
            }
            .largeButton()
        }
        .disabled(!store.isValidInput)
    }
}

#Preview {
    LoanReturnedView(
        store: .init(
            initialState: .init(admin: .mock),
            reducer: LoanReturned.init
        )
    )
}
