import ComposableArchitecture
import XCTest

@testable import LogsFeatureV2

@MainActor
final class LogsTest: XCTestCase {
    func test_FetchLogs_OnFirstAppear() async {
        let store = TestStore(initialState: Logs.State()) {
            Logs()
        } withDependencies: {
            $0.userApiClient.fetchLogs = { return [] }
        }
        
        store.exhaustivity = .off
        
        await store.send(.onAppear) {
            $0.isLoading = true
        }
        
        await store.receive(\.fetchLogs)
    }
    
    func test_FetchNoLogs_OnSecondAppear() async {
        var state = Logs.State()
        state.logs = [.mockExtra]
        
        let store = TestStore(initialState: state) {
            Logs()
        }
        
        await store.send(.onAppear)
        
    }
    
    func test_FetchLogs_OnPullToRefresh() async {
        let clock = TestClock()
        let store = TestStore(initialState: Logs.State()) {
            Logs()
        } withDependencies: {
            $0.continuousClock = clock
            $0.userApiClient.fetchLogs = { return [.mockExtra ] }
        }
        
        await store.send(.pulledToRefresh) {
            $0.isPullToRefresh = true
        }
        
        await clock.advance(by: .seconds(1))
        await store.receive(\.fetchLogs)
        await store.receive(\.logsResponse.success) {
            $0.isPullToRefresh = false
            $0.logs = [.mockExtra]
            $0.groupedLogs = $0.logs.groupByYearAndMonth()
        }
    }
    
    func test_ScrollsToTop_OnTabBarTapped() async {
        let store = TestStore(initialState: Logs.State()) {
            Logs()
        }
        
        await store.send(.tabBarTapped) {
            $0.needsScrollToTop = true
        }
        
        await store.send(.scrolledToTop) {
            $0.needsScrollToTop = false
        }
    }
    
    func test_FetchLogs_SuccessFlow() async {
        let store = TestStore(initialState: Logs.State()) {
            Logs()
        } withDependencies: {
            $0.userApiClient.fetchLogs = { return [.mockExtra] }
        }
        
        await store.send(.onAppear) {
            $0.isLoading = true
        }
        await store.receive(\.fetchLogs)
        await store.receive(\.logsResponse.success) {
            $0.isLoading = false
            $0.logs = [.mockExtra]
            $0.groupedLogs = $0.logs.groupByYearAndMonth()
        }
    }
    
    func test_FetchLogs_ErrorFlow() async {
        struct SomeError: Error, Equatable { }
        let store = TestStore(initialState: Logs.State()) {
            Logs()
        } withDependencies: {
            $0.userApiClient.fetchLogs = { throw SomeError() }
        }
        
        await store.send(.onAppear) {
            $0.isLoading = true
        }
        await store.receive(\.fetchLogs)
        await store.receive(\.logsResponse.failure) {
            $0.isLoading = false
            $0.destination = .alert(.onError(SomeError()))
        }
        
        await store.send(.destination(.dismiss)) {
            $0.destination = nil
        }
    }
}
