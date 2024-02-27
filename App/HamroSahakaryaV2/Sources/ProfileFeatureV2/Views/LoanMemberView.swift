import SwiftUI
import ComposableArchitecture

public struct LoanMemberView: View {
    public init(store: StoreOf<LoanMember>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<LoanMember>
    
    public var body: some View {
        Text("Hello World")
    }
}

#Preview {
    LoanMemberView(
        store: .init(
            initialState: .init(),
            reducer: LoanMember.init
        )
    )
}
