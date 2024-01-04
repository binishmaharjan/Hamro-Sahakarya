import ComposableArchitecture
import XCTest

@testable import AppFeatureV2

@MainActor
final class LaunchTests: XCTestCase {
    
    func test_ShowSignIn_When_NoSavedUser() async {
        let store = TestStore(initialState: Launch.State()) {
            Launch()
        } withDependencies: {
            $0.userDefaultsClient.userAccount = { nil }
        }
        
        await store.send(.onAppear)
        await store.receive(\.fetchUserAccount)
        await store.receive(.delegate(.showSignInView))
    }
    
    func test_ShowMain_When_SavedUser() async {
        let store = TestStore(initialState: Launch.State()) {
            Launch()
        } withDependencies: {
            $0.userDefaultsClient.userAccount = { .mock }
        }
        
        await store.send(.onAppear)
        await store.receive(\.fetchUserAccount)
        await store.receive(.delegate(.showMainView(.mock)))
    }
}
