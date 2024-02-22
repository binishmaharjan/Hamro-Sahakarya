import ComposableArchitecture
import XCTest

@testable import ProfileFeatureV2

@MainActor
final class ExtraIncomeAndExpensesTests: XCTestCase {
    func test_Type_Changed() async {
        let store = TestStore(initialState: ExtraIncomeAndExpenses.State(user: .mock)) {
            ExtraIncomeAndExpenses()
        }
        
        XCTAssertEqual(store.state.type, .extra)
        await store.send(.typeFieldTapped) {
            $0.destination = .confirmationDialog(.selectType)
        }
        
        await store.send(.destination(.presented(.confirmationDialog(.presented(.expensesTapped))))) {
            $0.destination = nil
            $0.type = .expenses
        }
        
        await store.send(.typeFieldTapped) {
            $0.destination = .confirmationDialog(.selectType)
        }
        
        await store.send(.destination(.presented(.confirmationDialog(.presented(.extraTapped))))) {
            $0.destination = nil
            $0.type = .extra
        }
    }
    
    func test_IsValidInput() async {
        let store = TestStore(initialState: ExtraIncomeAndExpenses.State(user: .mock)) {
            ExtraIncomeAndExpenses()
        }
        
        XCTAssertFalse(store.state.isValidInput)
        await store.send(.set(\.amount, "5000")) {
            $0.amount = "5000"
        }
        
        XCTAssertFalse(store.state.isValidInput)
        await store.send(.set(\.reason, "Test")) {
            $0.reason = "Test"
        }
        
        XCTAssertTrue(store.state.isValidInput)
    }
    
    func test_AddExtraOrExpenses_SuccessFlow() async {
        let store = TestStore(initialState: ExtraIncomeAndExpenses.State(user: .mock)) {
            ExtraIncomeAndExpenses()
        } withDependencies: {
            $0.userApiClient.addExtraAndExpenses = { _, _, _, _ in Void() }
        }
        
        await store.send(.updateButtonTapped) {
            $0.isLoading = true
        }
        
        await store.receive(.addExtraOrExpensesResponse(.success(.init()))) {
            $0.isLoading = false
            $0.destination = .alert(.onUpdateSuccessful())
        }
    }
    
    func test_AddExtraOrExpenses_FailureFlow() async {
        struct SomeError: Error, Equatable { }
        let store = TestStore(initialState: ExtraIncomeAndExpenses.State(user: .mock)) {
            ExtraIncomeAndExpenses()
        } withDependencies: {
            $0.userApiClient.addExtraAndExpenses = { _, _, _, _ in throw SomeError() }
        }
        
        await store.send(.updateButtonTapped) {
            $0.isLoading = true
        }
        
        await store.receive(.addExtraOrExpensesResponse(.failure(SomeError()))) {
            $0.isLoading = false
            $0.destination = .alert(.onError(SomeError()))
        }
    }
}
