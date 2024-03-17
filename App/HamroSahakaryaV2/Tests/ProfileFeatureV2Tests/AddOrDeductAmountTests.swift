import ComposableArchitecture
import XCTest

@testable import ProfileFeatureV2

@MainActor
final class AddOrDeductAmountTests: XCTestCase {
    func test_FetchMemberList_OnFirstAppear() async {
        let store = TestStore(initialState: AddOrDeductAmount.State(admin: .mock)) {
            AddOrDeductAmount()
        } withDependencies: {
            $0.userApiClient.fetchAllMembers = { return [.mock] }
        }
        
        await store.send(.onAppear) {
            $0.isLoading = true
        }
        
        await store.receive(\.membersListResponse.success) {
            $0.isLoading = false
            $0.members = [.mock]
            $0.memberSelect = .init(members: [.mock], mode: .membersOnly)
        }
    }
    
    func test_FetchNoMemberList_OnSecondAppear() async {
        let store = TestStore(initialState: AddOrDeductAmount.State(admin: .mock)) {
            AddOrDeductAmount()
        } withDependencies: {
            $0.userApiClient.fetchAllMembers = { return [.mock] }
        }
        
        await store.send(.onAppear) {
            $0.isLoading = true
        }
        
        await store.receive(\.membersListResponse.success) {
            $0.isLoading = false
            $0.members = [.mock]
            $0.memberSelect = .init(members: [.mock], mode: .membersOnly)
        }
        
        await store.send(.onAppear)
    }
    
    func test_Type_Changed() async {
        let store = TestStore(initialState: AddOrDeductAmount.State(admin: .mock)) {
            AddOrDeductAmount()
        }
        
        XCTAssertEqual(store.state.type, .add)
        await store.send(.typeFieldTapped) {
            $0.destination = .confirmationDialog(.selectType)
        }
        
        await store.send(.destination(.presented(.confirmationDialog(.deductTapped)))) {
            $0.destination = nil
            $0.type = .deduct
        }
        
        await store.send(.typeFieldTapped) {
            $0.destination = .confirmationDialog(.selectType)
        }
        
        await store.send(.destination(.presented(.confirmationDialog(.addTapped)))) {
            $0.destination = nil
            $0.type = .add
        }
    }
    
    func test_IsValidInput() async {
        let store = TestStore(initialState: AddOrDeductAmount.State(admin: .mock)) {
            AddOrDeductAmount()
        }
        
        XCTAssertFalse(store.state.isValidInput)
        await store.send(.set(\.amount, "5000")) {
            $0.amount = "5000"
        }
        
        XCTAssertTrue(store.state.isValidInput)
    }
    
    func test_FetchMemberList_SuccessFlow() async {
        let store = TestStore(initialState: AddOrDeductAmount.State(admin: .mock)) {
            AddOrDeductAmount()
        } withDependencies: {
            $0.userApiClient.fetchAllMembers = { return [.mock] }
        }
        
        await store.send(.onAppear) {
            $0.isLoading = true
        }
        
        await store.receive(\.membersListResponse.success) {
            $0.isLoading = false
            $0.members = [.mock]
            $0.memberSelect = .init(members: [.mock], mode: .membersOnly)
        }
    }
    
    func test_FetchMemberList_ErrorFlow() async {
        struct SomeError: Error, Equatable { }
        let store = TestStore(initialState: AddOrDeductAmount.State(admin: .mock)) {
            AddOrDeductAmount()
        } withDependencies: {
            $0.userApiClient.fetchAllMembers = { throw SomeError() }
        }
        
        await store.send(.onAppear) {
            $0.isLoading = true
        }
        
        await store.receive(\.membersListResponse.failure) {
            $0.isLoading = false
            $0.destination = .alert(.onError(SomeError()))
        }
    }
    
    func test_LoanMember_SuccessFlow() async {
        let store = TestStore(initialState: AddOrDeductAmount.State(admin: .mock)) {
            AddOrDeductAmount()
        } withDependencies: {
            $0.userApiClient.addOrDeductAmount = { _, _, _, _ in Void() }
        }
        
        await store.send(.set(\.amount, "500")) {
            $0.amount = "500"
        }
        
        await store.send(.set(\.memberSelect.selectedMembers, [.mock])) {
            $0.memberSelect.selectedMembers = [.mock]
        }
        
        await store.send(.updateButtonTapped) {
            $0.isLoading = true
        }
        
        await store.receive(\.addOrDeductAmountResponse.success) {
            $0.isLoading = false
            $0.amount = ""
            $0.destination = .alert(.onUpdateSuccessful())
        }
    }
    
    func test_LoanMember_FailureFlow() async {
        struct SomeError: Error, Equatable { }
        let store = TestStore(initialState: AddOrDeductAmount.State(admin: .mock)) {
            AddOrDeductAmount()
        } withDependencies: {
            $0.userApiClient.addOrDeductAmount = { _, _, _, _ in throw SomeError() }
        }
        
        await store.send(.set(\.amount, "500")) {
            $0.amount = "500"
        }
        
        await store.send(.set(\.memberSelect.selectedMembers, [.mock])) {
            $0.memberSelect.selectedMembers = [.mock]
        }
        
        await store.send(.updateButtonTapped) {
            $0.isLoading = true
        }
        
        await store.receive(\.addOrDeductAmountResponse.failure) {
            $0.isLoading = false
            $0.destination = .alert(.onError(SomeError()))
        }
    }
}
