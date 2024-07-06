import SwiftUI
import ComposableArchitecture
import SharedUIs

public struct LogsView: View {
    private enum Configuration {
        static var scrollToTopId = UUID().uuidString
    }
    public init(store: StoreOf<Logs>) {
        self.store = store
    }
    
    private static var scrollDelegate = ScrollViewModel()
    @Bindable private var store: StoreOf<Logs>
    
    public var body: some View {
        NavigationStack {
            ScrollViewReader { value in
                CustomRefreshView(scrollDelegate: LogsView.scrollDelegate) {
                    Spacer()
                        .frame(height: 0)
                        .id(Configuration.scrollToTopId)
                    
                    LazyVStack {
                        ForEach(store.groupedLogs, id: \.self) { groupedLogs in
                            Section {
                                ForEach(groupedLogs.logs, id: \.self) { log in
                                    LogItemView(groupLog: log)
                                        .padding(.bottom, 8)
                                }
                            } header: {
                                Text(groupedLogs.title)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.customSubHeadline2)
                                    .foregroundStyle(#color("gray"))
                                    .padding(.leading, 24)
                                    .padding(.bottom, 8)
                                    .padding(.top, 16)
                            }
                        }
                    }
                } onRefresh: {
                    // Send Action to Reducer
                    store.send(.pulledToRefresh)
                    // Waiting until the state changes back
                    while store.isPullToRefresh {
                        try? await Task.sleep(nanoseconds: 1 * 1_00)
                    }
                }
                .onChange(of: store.needsScrollToTop) { _, newValue in
                    guard newValue else { return }
                    withAnimation {
                        value.scrollTo(Configuration.scrollToTopId, anchor: .top)
                    }
                    store.send(.scrolledToTop)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .customNavigationBar(#localized("Logs"))
            .background(#color("background"))
            .loadingView(store.isLoading)
            .onAppear { store.send(.onAppear) }
            .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
        }
    }
}

#Preview {
    LogsView(
        store: .init(
            initialState: .init(),
            reducer: Logs.init
        )
    )
}
