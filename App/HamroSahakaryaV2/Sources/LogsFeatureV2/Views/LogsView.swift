import SwiftUI
import ComposableArchitecture
import SharedUIs

public struct LogsView: View {
    public init(store: StoreOf<Logs>) {
        self.store = store
    }
    
    // MARK: If ScrollViewModel is hold by CustomRefreshView,
    // then the scrollViewModel state is reset when TCA state is also changed.
    // So passing the static instance so that ScrollViewModel state does not change.
    private static var scrollDelegate = ScrollViewModel()
    private let store: StoreOf<Logs>
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationStack {
                CustomRefreshView(scrollDelegate: LogsView.scrollDelegate, navigationHeight: 50) {
                    // MARK: Adding a clear frame to avoid space from Custom Navigation Bar
                    Color.clear
                        .frame(height: 50)

                    ForEach(viewStore.groupedLogs, id: \.self) { groupedLogs in
                        Section {
                            ForEach(groupedLogs.logs, id: \.self) { log in
                                LogItemView(groupLog: log)
                                    .padding(.bottom, 4)
                            }
                        } header: {
                            Text(groupedLogs.title)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.customSubHeadline2)
                                .foregroundStyle(#color("gray"))
                                .padding(.leading, 24)
                                .padding(.bottom, 8)
                        }
                    }
                } onRefresh: {
                    try! await Task.sleep(nanoseconds: 3_000_000_000)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay(
                    NavigationBar(title: "Logs")
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                )
                .navigationBarHidden(true)
                .background(#color("background"))
                .loadingView(viewStore.isLoading)
                .onAppear { viewStore.send(.onAppear) }
                .alert(
                    store: store.scope(state: \.$destination.alert, action: \.destination.alert)
                )
            }
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
