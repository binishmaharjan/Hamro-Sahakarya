import SwiftUI
import ComposableArchitecture
import SharedUIs
import PDFViewer

public struct TermsAndConditionView: View {
    public init(store: StoreOf<TermsAndCondition>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<TermsAndCondition>
    
    public var body: some View {
        VStack(spacing: 24) {
            PDFViewer(pdfDocument: store.pdfDocument)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(#color("background"))
        .customNavigationBar(#localized("Terms And Condition"))
        .loadingView(store.isLoading)
        .onAppear { store.send(.onAppear) }
    }
}

#Preview {
    TermsAndConditionView(
        store: .init(
            initialState: .init(),
            reducer: TermsAndCondition.init
        )
    )
}
