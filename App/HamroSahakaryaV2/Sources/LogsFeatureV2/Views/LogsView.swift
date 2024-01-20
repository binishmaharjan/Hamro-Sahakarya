import SwiftUI
import ComposableArchitecture
import SharedUIs

public struct LogsView: View {
    public init(store: StoreOf<Logs>) {
        self.store = store
    }
    
    private let store: StoreOf<Logs>
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationStack {
                ScrollView {
                    Group {
                        ForEach(viewStore.groupedLogs, id: \.self) { groupedLogs in
                            Section {
                                ForEach(groupedLogs.logs, id: \.self) { log in
                                    LogItemView(groupLog: log)
                                }
                            } header: {
                                Text(groupedLogs.title)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.customSubHeadline2)
                                    .foregroundStyle(#color("gray"))
                                    .padding(.leading, 24)
                            }
                        }
                    }
                    .padding(.top, 60)
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
