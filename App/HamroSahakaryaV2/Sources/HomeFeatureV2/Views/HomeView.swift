import SwiftUI
import ComposableArchitecture
import SharedUIs
import SharedModels
import Charts

public struct HomeView: View {
    public init(store: StoreOf<Home>) {
        self.store = store
    }
    
    private static var scrollDelegate = ScrollViewModel()
    @Bindable private var store: StoreOf<Home>
    @State private var pieSelection: Double?
    
    public var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                CustomRefreshView(scrollDelegate: Self.scrollDelegate) {
                    VStack {
                        // Paging View
                        ScrollView(.horizontal) {
                            LazyHStack(spacing: 0) {
                                ForEach(CardTypes.allCases, id: \.self) { _ in
                                    VStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(.gray)
                                    }
                                    .padding(.horizontal, 20)
                                    .containerRelativeFrame(.horizontal)
                                }
                            }
                            .defaultPagingIndicator()
                        }
                        .scrollTargetBehavior(.paging)
                        .scrollIndicators(.hidden)
                        .frame(height: 170)
                        .padding(.top, 20)
                        .padding(.bottom, 8)
                        
                        VStack {
                            Text(#localized("Member Graph"))
                                .foregroundStyle(#color("large_button"))
                                .font(.customHeadline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(store.memberCount)
                                .foregroundStyle(#color("gray"))
                                .font(.customCaption)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack {
                                chartView
                                
                                if let homeResponse = store.homeResponse {
                                    LegendView(type: .title)
                                    ForEach(homeResponse.allMembers) { member in
                                        LegendView(type: .row, member: member, isUser: store.user.id == member.id)
                                    }
                                }
                            }
                        }
                        .frame(maxHeight: .infinity)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                        .onChange(of: pieSelection) { oldValue, newValue in
                            if let newValue {
                                findSelectedUser(newValue)
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
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .customNavigationBar(#localized("Home"))
                .background(#color("background"))
                .loadingView(store.isLoading)
                .onAppear { store.send(.onAppear) }
                .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
            }
        }
    }
}

// MARK: Views
extension HomeView {
    private var chartView: some View {
        ZStack {
            VStack {
                Text(store.selectedUserAmount)
                    .foregroundStyle(#color("large_button"))
                    .font(.headline)
                
                Text(store.selectedUserName)
                    .foregroundStyle(#color("gray"))
                    .font(.customCaption)
            }
            
            Chart {
                ForEach(store.homeResponse?.allMembers ?? []) { user in
                    SectorMark(
                        angle: .value("Amount", user.balance),
                        innerRadius: .ratio(0.7),
                        angularInset: 0.6
                    )
                    .foregroundStyle(Color(hex: user.colorHex))
                    .opacity(store.chartSelectedUserId == user.id ? 1.0 : 0.4)
                }
            }
            .chartAngleSelection(value: $pieSelection)
        }
        .frame(height: 200)
    }
}

// MARK: Chart + Helper
extension HomeView {
    /*
     Selection of chart value returns a range value
     For example: if pie chart has six things and the overall sum is 2000, the selection
     return a value between 0 to 2000. So we must map a value to our app model to determine
     which item it falls upon.
     */
    private func findSelectedUser(_ rangeValue: Double) {
        guard let allMembers = store.homeResponse?.allMembers else { return }
        
        // Converting User into array of tuple
        var initialValue: Double = 0.0
        let convertedArray = allMembers.map { user -> (UserId, Range<Double>) in
            let rangeEnd = initialValue + Double(user.balance)
            let tuple = (user.id, initialValue ..< rangeEnd)
            initialValue = rangeEnd
            return tuple
        }

        // Finding the value that falls with in the range
        let selectedTuple = convertedArray.first { tuple in
            tuple.1.contains(rangeValue)
        }
        if let selectedTuple {
            store.send(.updateChartSelectedUserId(selectedTuple.0))
        }
    }
}

#Preview {
    HomeView(
        store: .init(
            initialState: .init(user: .mock),
            reducer: Home.init
        )
    )
}

// MARK: Home Cards
extension HomeView {
    enum CardTypes: CaseIterable {
        case myAccount
        case groudDetail
    }
}
