import SwiftUI
import ComposableArchitecture
import SharedUIs

public struct AddOrDeductAmountView: View {
    public init(store: StoreOf<AddOrDeductAmount>) {
        self.store = store
    }

    @Bindable private var store: StoreOf<AddOrDeductAmount>
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(alignment: .leading) {
                    Text(#localized("Type"))
                        .font(.customSubHeadline)
                        .foregroundStyle(#color("secondary"))
                    
                    TextField(#localized(""), text: .constant(store.type.rawValue))
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
                
                VStack {
                    Text(#localized("Select Target Members"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.customSubHeadline2)
                        .foregroundStyle(#color("gray"))
                    
                    MemberSelectView(store: store.scope(state: \.memberSelect, action: \.memberSelect))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                updateButton
                
                Spacer()
            }
            .padding(20)
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(#color("background"))
        .customNavigationBar(#localized("Add Or Deduct Amount"))
        .loadingView(store.isLoading)
        .onAppear { store.send(.onAppear) }
        .confirmationDialog(
            $store.scope(state: \.destination?.confirmationDialog, action: \.destination.confirmationDialog)
        )
        .alert(
            $store.scope(state: \.destination?.alert, action: \.destination.alert)
        )

    }
}

// MARK: View Parts
extension AddOrDeductAmountView {
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
    AddOrDeductAmountView(
        store: .init(
            initialState: .init(admin: .mock),
            reducer: AddOrDeductAmount.init
        )
    )
}
