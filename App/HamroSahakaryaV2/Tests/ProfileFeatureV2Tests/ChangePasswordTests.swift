import ComposableArchitecture
import XCTest

@testable import ProfileFeatureV2

@MainActor
final class ChangePasswordTests: XCTestCase {
    func test_Password_DoesNotMatch() async {
        var state = ChangePassword.State(user: .mock)
        let store = TestStore(initialState: state) {
            ChangePassword()
        }
        
        state.password = "password"
        state.password = "wrong-password"
        
        await store.send(.changePasswordTapped)
        await store.receive(.passwordDoesNotMatch) {
            $0.destination = .alert(.passwordDoesNotMatch())
        }
    }
}
