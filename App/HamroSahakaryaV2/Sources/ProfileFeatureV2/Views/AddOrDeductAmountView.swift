import SwiftUI
import ComposableArchitecture

public struct AddOrDeductAmountView: View {
    public init(store: StoreOf<AddOrDeductAmount>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<AddOrDeductAmount>
    
    public var body: some View {
        Text("Add Or Deduct Amount")
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
