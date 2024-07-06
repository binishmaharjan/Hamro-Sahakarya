import SwiftUI
import ComposableArchitecture
import SharedUIs

public struct ExtraIncomeAndExpensesView: View {
    public init(store: StoreOf<ExtraIncomeAndExpenses>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<ExtraIncomeAndExpenses>
    
    public var body: some View {
        VStack(spacing: 24) {
            VStack(alignment: .leading) {
                Text(#localized("Type"))
                    .font(.customSubHeadline)
                    .foregroundStyle(#color("secondary"))
                
                TextField(#localized(""), text: .constant(store.type.title))
                    .textFieldStyle(
                        .tapOnly(#img("icon_person")) { store.send(.typeFieldTapped) }
                    )
            }
            
            VStack(alignment: .leading) {
                Text(#localized("Amount"))
                    .font(.customSubHeadline)
                    .foregroundStyle(#color("secondary"))
                
                TextField(#localized("Amount"), text: $store.amount)
                    .textFieldStyle(.icon(#img("icon_yen")))
                    .keyboardType(.numberPad)
            }
            
            VStack(alignment: .leading) {
                Text(#localized("Reason"))
                    .font(.customSubHeadline)
                    .foregroundStyle(#color("secondary"))
                
                TextField(#localized("Reason"), text: $store.reason, axis: .vertical)
                    .lineLimit(5)
                    .textFieldStyle(.icon(#img("icon_person")))
            }
            
            updateButton
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(20)
        .padding()
        .background(#color("background"))
        .customNavigationBar(#localized("Extra Income And Expenses"))
        .loadingView(store.isLoading)
        .confirmationDialog(
            $store.scope(state: \.destination?.confirmationDialog, action: \.destination.confirmationDialog)
        )
        .alert(
            $store.scope(state: \.destination?.alert, action: \.destination.alert)
        )
    }
}

// MARK: View Parts
extension ExtraIncomeAndExpensesView {
    private var updateButton: some View {
        Button {
            store.send(.updateButtonTapped)
        } label: {
            HStack {
                Image(systemName: "arrow.right")
                Text(#localized("Update"))
                    .font(.customHeadline)
            }
            .largeButton()
        }
        .disabled(!store.isValidInput)
    }
}

#Preview {
    ExtraIncomeAndExpensesView(
        store: .init(
            initialState: .init(admin: .mock),
            reducer: ExtraIncomeAndExpenses.init
        )
    )
}
