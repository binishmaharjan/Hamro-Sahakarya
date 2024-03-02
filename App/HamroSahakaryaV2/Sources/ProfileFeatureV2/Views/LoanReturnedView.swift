import SwiftUI
import ComposableArchitecture

public struct LoanReturnedView: View {
    public init(store: StoreOf<LoanReturned>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<LoanReturned>
    
    public var body: some View {
        Text("Loan Returned")
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
