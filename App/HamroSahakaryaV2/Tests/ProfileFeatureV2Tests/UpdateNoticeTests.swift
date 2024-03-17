import ComposableArchitecture
import XCTest

@testable import ProfileFeatureV2

@MainActor
final class UpdateNoticeTests: XCTestCase {
    func test_IsValidInput() async {
        let store = TestStore(initialState: UpdateNotice.State(admin: .mock)) {
            UpdateNotice()
        }
        
        XCTAssertFalse(store.state.isValidInput)
        await store.send(.set(\.notice, "Tests")) {
            $0.notice = "Tests"
        }
        
        XCTAssertTrue(store.state.isValidInput)
    }
    
    func test_UpdateNotice_SuccessFlow() async {
        let store = TestStore(initialState: UpdateNotice.State(admin: .mock)) {
            UpdateNotice()
        } withDependencies: {
            $0.userApiClient.updateNotice = { _, _ in Void() }
        }
        
        await store.send(.set(\.notice, "Tests")) {
            $0.notice = "Tests"
        }
        
        await store.send(.updateButtonTapped) {
            $0.isLoading = true
        }
        
        await store.receive(\.updateNoticeResponse.success) {
            $0.notice = ""
            $0.isLoading = false
            $0.destination = .alert(.onUpdateSuccessful())
        }
    }
    
    func test_UpdateNotice_ErrorFlow() async {
        struct SomeError: Error, Equatable { }
        let store = TestStore(initialState: UpdateNotice.State(admin: .mock)) {
            UpdateNotice()
        } withDependencies: {
            $0.userApiClient.updateNotice = { _, _ in throw SomeError() }
        }
        
        await store.send(.set(\.notice, "Tests")) {
            $0.notice = "Tests"
        }
        
        await store.send(.updateButtonTapped) {
            $0.isLoading = true
        }
        
        await store.receive(\.updateNoticeResponse.failure) {
            $0.isLoading = false
            $0.destination = .alert(.onError(SomeError()))
        }
    }
}
