import ComposableArchitecture
import XCTest
import SharedModels
import SharedUIs

@testable import OnboardingFeatureV2

@MainActor
final class ForgotPasswordTests: XCTestCase {
    
    func test_IsValidEmail() async {
        let store = TestStore(initialState: ForgotPassword.State()) {
            ForgotPassword()
        }
        
        await store.send(.set(\.$email, "a")) {
            $0.email = "a"
        }
        XCTAssertFalse(store.state.isValidInput)
        
        await store.send(.set(\.$email, "a@b.com")){
            $0.email = "a@b.com"
        }
        XCTAssertTrue(store.state.isValidInput)
    }
    
    func test_ForgotPassword_SuccessFlow() async {
        let store = TestStore(initialState: ForgotPassword.State()) {
            ForgotPassword()
        } withDependencies: {
            $0.userAuthClient.sendPasswordReset = { _ in return Void() }
        }
        
        await store.send(.forgotPasswordButtonTapped) {
            $0.isLoading = true
        }
        
        await store.receive(\.sendPasswordReset.success) {
            $0.isLoading = false
            $0.destination = .alert(
                AlertState<ForgotPassword.Destination.Action.Alert> {
                    TextState(#localized("Email Sent"))
                } actions: {
                    ButtonState { TextState(#localized("Ok")) }
                } message: {
                    TextState(#localized("Please check your email and follow the instructions sent to that email."))
                }
            )
        }
        
        await store.send(.destination(.dismiss)) {
            $0.destination = nil
        }
    }
    
    func test_ForgotPassword_ErrorFlow() async {
        struct SomeError: Error, Equatable {}
        let store = TestStore(initialState: ForgotPassword.State()) {
            ForgotPassword()
        } withDependencies: {
            $0.userAuthClient.sendPasswordReset = { _ in throw SomeError() }
        }
        
        await store.send(.forgotPasswordButtonTapped) {
            $0.isLoading = true
        }
        
        await store.receive(\.sendPasswordReset.failure) {
            $0.isLoading = false
            $0.destination = .alert(
                AlertState<ForgotPassword.Destination.Action.Alert> {
                    TextState(#localized("Error"))
                } actions: {
                    ButtonState { TextState(#localized("Cancel")) }
                } message: {
                    TextState(SomeError().localizedDescription)
                }
            )
        }
        
        await store.send(.destination(.dismiss)) {
            $0.destination = nil
        }
    }
}
