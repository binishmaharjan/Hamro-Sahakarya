import ComposableArchitecture
import XCTest
import SwiftHelpers

@testable import ProfileFeatureV2

@MainActor
final class ChangePasswordTests: XCTestCase {
    func test_IsValidInput() async {
        let store = TestStore(initialState: ChangePassword.State(user: .mock)) {
            ChangePassword()
        }
        
        XCTAssertFalse(store.state.isValidInput)
        
        await store.send(.set(\.password, "password")) {
            $0.password = "password"
        }
        
        XCTAssertFalse(store.state.isValidInput)
        
        await store.send(.set(\.confirmPassword, "password")) {
            $0.confirmPassword = "password"
        }
        
        XCTAssertTrue(store.state.isValidInput)
    }
    
    func test_Password_DoesNotMatch() async {
        let store = TestStore(initialState: ChangePassword.State(user: .mock)) {
            ChangePassword()
        }
        
        await store.send(.set(\.password, "password")) {
            $0.password = "password"
        }
        await store.send(.set(\.confirmPassword, "wrong-password")) {
            $0.confirmPassword = "wrong-password"
        }
        
        await store.send(.changePasswordTapped)
        await store.receive(\.passwordDoesNotMatch) {
            $0.destination = .alert(.passwordDoesNotMatch())
        }
    }
    
    func test_Password_Match() async {
        let store = TestStore(initialState: ChangePassword.State(user: .mock)) {
            ChangePassword()
        } withDependencies: {
            $0.userApiClient.changePassword = { _, _ in return Void() }
        }
        
        store.exhaustivity = .off
        
        await store.send(.set(\.password, "password")) {
            $0.password = "password"
        }
        await store.send(.set(\.confirmPassword, "password")) {
            $0.confirmPassword = "password"
        }
        
        await store.send(.changePasswordTapped)
        await store.receive(\.changePasswordResponse.success)
    }
    
    func test_ChangePassword_SuccessFlow() async {
        let store = TestStore(initialState: ChangePassword.State(user: .mock)) {
            ChangePassword()
        } withDependencies: {
            $0.userApiClient.changePassword = { _, _ in return Void() }
        }
        
        await store.send(.changePasswordTapped) {
            $0.isLoading = true
        }
        
        await store.receive(\.changePasswordResponse.success) {
            $0.isLoading = false
            $0.destination = .alert(.changePasswordSuccess())
        }
    }
    
    func test_ChangePassword_FailureFlow() async {
        struct SomeError: Error, Equatable { }
        let store = TestStore(initialState: ChangePassword.State(user: .mock)) {
            ChangePassword()
        } withDependencies: {
            $0.userApiClient.changePassword = { _, _ in throw SomeError() }
        }
        
        await store.send(.changePasswordTapped) {
            $0.isLoading = true
        }
        
        await store.receive(\.changePasswordResponse.failure) {
            $0.isLoading = false
            $0.destination = .alert(.onError(SomeError()))
        }
    }
    
    func test_SignOut_SuccessFlow() async {
        let store = TestStore(initialState: ChangePassword.State(user: .mock)) {
            ChangePassword()
        } withDependencies: {
            $0.userApiClient.signOut = { Void() }
        }
        
        await store.send(.signOutUser) {
            $0.isLoading = true
        }
        
        await store.receive(\.signOutResponse.success) {
            $0.isLoading = false
        }
        
        await store.receive(\.delegate.signOutSuccessful)
    }
    
    func test_SignOut_FailureFlow() async {
        struct SomeError: Error, Equatable { }
        let store = TestStore(initialState: ChangePassword.State(user: .mock)) {
            ChangePassword()
        } withDependencies: {
            $0.userApiClient.signOut = { throw SomeError() }
        }
        
        await store.send(.signOutUser) {
            $0.isLoading = true
        }
        
        await store.receive(\.signOutResponse.failure) {
            $0.isLoading = false
            $0.destination = .alert(.onError(SomeError()))
        }
    }
}
