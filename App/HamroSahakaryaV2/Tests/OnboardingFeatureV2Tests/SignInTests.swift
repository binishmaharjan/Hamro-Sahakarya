import ComposableArchitecture
import XCTest
import SharedModels
import SharedUIs

@testable import OnboardingFeatureV2

@MainActor
final class SignInTests: XCTestCase {
    func test_IsValidInput() async {
        let store = TestStore(initialState: SignIn.State()) {
            SignIn()
        }
        
        await store.send(.set(\.email, "a@b.com")) {
            $0.email = "a@b.com"
        }
        XCTAssertFalse(store.state.isValidInput)
        
        await store.send(.set(\.password, "password")) {
            $0.password = "password"
        }
        XCTAssertTrue(store.state.isValidInput)
    }
    
    func test_ForgotButton_Tapped() async {
        let store = TestStore(initialState: SignIn.State()) {
            SignIn()
        }
        
        await store.send(.forgotPasswordButtonTapped) {
            $0.destination = .forgotPassword(.init())
        }
    }
    
    func test_VerifyAdminPassword_SuccessFlow() async {
        let testClock = TestClock()
        let store = TestStore(initialState: SignIn.State()) {
            SignIn()
        } withDependencies: {
            $0.continuousClock = testClock
        }
        
        await store.send(.viewTappedTwice) {
            $0.destination = .adminPasswordInput(.init())
        }
        
        await store.send(.destination(.presented(.adminPasswordInput(.delegate(.verifyAdminPassword("admin")))))) {
            $0.destination = nil
        }
        
        await testClock.advance(by: .seconds(0.3))
        await store.receive(\.isAdminPasswordVerified) {
            $0.destination = .createUser(.init())
        }
    }
    
    func test_VerifyAdminPassword_FailureFlow() async {
        let testClock = TestClock()
        let store = TestStore(initialState: SignIn.State()) {
            SignIn()
        } withDependencies: {
            $0.continuousClock = testClock
        }
        
        await store.send(.viewTappedTwice) {
            $0.destination = .adminPasswordInput(.init())
        }
        
        await store.send(.destination(.presented(.adminPasswordInput(.delegate(.verifyAdminPassword("wrong_password")))))) {
            $0.destination = nil
        }
        
        await testClock.advance(by: .seconds(0.3))
        await store.receive(\.isAdminPasswordVerified) {
            $0.destination = .alert(.adminPasswordVerificationFailed())
        }
    }
    
    func test_SecureButton_Tapped() async {
        let store = TestStore(initialState: SignIn.State()) {
            SignIn()
        }
        
        XCTAssertEqual(store.state.isSecure, true)
        
        await store.send(.isSecureButtonTapped) {
            $0.isSecure = false
        }
        
        await store.send(.isSecureButtonTapped) {
            $0.isSecure = true
        }
    }
    
    func test_SignIn_SuccessFlow() async {
        let store = TestStore(initialState: SignIn.State()) {
            SignIn()
        } withDependencies: {
            $0.userApiClient.signIn = { _, _ in return .mock }
        }
        
        await store.send(.signInButtonTapped) {
            $0.isLoading = true
        }
        
        await store.receive(\.signInResponse.success) {
            $0.isLoading = false
        }
        
        await store.receive(\.delegate.authenticationSuccessful)
    }
    
    func test_SignIn_ErrorFlow() async {
        struct SomeError: Error, Equatable {}
        let store = TestStore(initialState: SignIn.State()) {
            SignIn()
        } withDependencies: {
            $0.userApiClient.signIn = { _, _ in throw SomeError() }
        }
        
        await store.send(.signInButtonTapped) {
            $0.isLoading = true
        }
        
        await store.receive(\.signInResponse.failure) {
            $0.isLoading = false
            $0.destination = .alert(
                AlertState<SignIn.Destination.Action.Alert> {
                    TextState(#localized("Error"))
                } actions: {
                    ButtonState { TextState(#localized("Ok")) }
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
