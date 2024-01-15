import SwiftUI
import ComposableArchitecture
import SharedUIs

public struct LogsView: View {
    public init(store: StoreOf<Logs>) {
        self.store = store
    }
    
    private let store: StoreOf<Logs>
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                Group {
                    Section {
                        ForEach(0..<2) { int in
                            LogItemView(groupLog: .mockJoined)
                        }
                    } header: {
                        Text("January, 2024")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.customSubHeadline2)
                            .foregroundStyle(#color("gray"))
                            .padding(.leading, 24)
                    }
                    
                    Section {
                        ForEach(0..<2) { int in
                            LogItemView(groupLog: .mockJoined)
                        }
                    } header: {
                        Text("January, 2024")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.customSubHeadline2)
                            .foregroundStyle(#color("gray"))
                            .padding(.leading, 24)
                            .padding(.vertical, 4)
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
