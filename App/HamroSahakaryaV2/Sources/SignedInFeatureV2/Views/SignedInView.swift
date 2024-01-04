import SwiftUI
import ComposableArchitecture
import SharedUIs
import HomeFeatureV2
import LogsFeatureV2
import ProfileFeatureV2

public struct SignedInView: View {
    public init(store: StoreOf<SignedIn>) {
        self.store = store
    }
    
    private let store: StoreOf<SignedIn>
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                TabView(selection: viewStore.$selectedTab) {
                    HomeView(store: store.scope(state: \.home, action: \.home))
                        .tag(Tab.home)
                    
                    LogsView(store: store.scope(state: \.logs, action: \.logs))
                        .tag(Tab.logs)
                    
                    ProfileView(store: store.scope(state: \.profile, action: \.profile))
                        .tag(Tab.profile)
                }
                
                tabBar(viewStore: viewStore)
            }
        }
    }
}

// MARK: View Parts
extension SignedInView {
    private func tabBar(viewStore: ViewStoreOf<SignedIn>) -> some View {
        HStack {
            tabItems(viewStore: viewStore)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(#color("background2").opacity(0.8))
        .background(.ultraThinMaterial)
        .shadow(color: #color("background2").opacity(0.3), radius: 20, x: 0, y: 20)
        .frame(maxHeight: .infinity, alignment: .bottom)
    }
    
    private func tabItems(viewStore: ViewStoreOf<SignedIn>) -> some View {
        ForEach(Tab.items) { item in
            Button {
                viewStore.send(.tabSelected(item.tab))
            } label: {
                item.icon
                    .frame(width: 36, height: 36)
                    .frame(maxWidth: .infinity)
                    .opacity(viewStore.selectedTab == item.tab ? 1.0 : 0.5)
                    .background(
                        VStack {
                            RoundedRectangle(cornerRadius: 2)
                                .frame(width: viewStore.selectedTab == item.tab ? 24 : 0, height: 4)
                                .offset(y: -4)
                                .opacity(viewStore.selectedTab == item.tab ? 1 : 0)
                            
                            Spacer()
                        }
                    )
                    .foregroundColor(#color("white"))
            }
        }
    }
}

#Preview {
    SignedInView(
        store: .init(
            initialState: .init(userSession: .mock),
            reducer: SignedIn.init
        )
    )
}
