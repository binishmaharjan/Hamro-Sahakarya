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
    // MARK: Tabbar Position
    @State var selectedXOffset: CGFloat = 0
    @State var xOffsetValues: [CGFloat] = [0, 0, 0]
    
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
        GeometryReader { proxy in
            let hasHomeIndicator = proxy.safeAreaInsets.bottom > 0
            
            HStack {
                tabItems(viewStore: viewStore)
            }
            .padding(.bottom, hasHomeIndicator ? 16 : 0)
            .frame(maxWidth: .infinity, maxHeight: hasHomeIndicator ? 88 : 64)
            .background(#color("background2").opacity(0.8))
            .background(.ultraThinMaterial)
            .overlay(
                Rectangle()
                    .foregroundStyle(#color("white"))
                    .frame(width: 44, height: 5)
                    .cornerRadius(2)
                    .offset(y: 4)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .offset(x: selectedXOffset)
            )
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea()
        }
    }
    
    private func tabItems(viewStore: ViewStoreOf<SignedIn>) -> some View {
        ForEach(Array(Tab.items.enumerated()), id: \.offset) { index, item in
            if index == 0 { Spacer() }
            
            Button {
                viewStore.send(.tabSelected(item.tab))
                withAnimation {
                    selectedXOffset = xOffsetValues[index]
                }
            } label: {
                VStack(spacing: 0) {
                    item.icon
                        .font(.customHeadline)
                        .frame(width: 44, height: 29)
                        .frame(maxWidth: .infinity)
                    
                    Text(item.tab.title)
                        .font(.customCaption)
                        .lineLimit(1)
                }
                .foregroundStyle(#color("white"))
                .overlay(
                    GeometryReader { proxy in
                        let offset = proxy.frame(in: .global).minX
                        
                        Color.clear.preference(key: TabPreferenceKey.self, value: offset)
                            .onPreferenceChange(TabPreferenceKey.self) { value in
                                xOffsetValues[index] = value
                                if viewStore.selectedTab == item.tab {
                                    selectedXOffset = xOffsetValues[index]
                                }
                            }
                    }
                )
            }
            .frame(width: 44)
            .frame(maxWidth: .infinity)
            .opacity(viewStore.selectedTab == item.tab ? 1.0 : 0.5)
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
