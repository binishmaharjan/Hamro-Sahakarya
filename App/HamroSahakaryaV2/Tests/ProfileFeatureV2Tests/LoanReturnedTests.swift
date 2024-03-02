import ComposableArchitecture
import XCTest

@testable import ProfileFeatureV2

@MainActor
final class LoanReturnedTests: XCTestCase {
    func test_FetchMemberList_OnFirstAppear() async {
        let store = TestStore(initialState: LoanReturned.State(admin: .mock)) {
            LoanReturned()
        } withDependencies: {
            $0.userApiClient.fetchAllMembersWithLoan = { return [.mock] }
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
        let store = TestStore(initialState: LoanReturned.State(admin: .mock)) {
            LoanReturned()
        } withDependencies: {
            $0.userApiClient.fetchAllMembersWithLoan = { return [.mock] }
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
    
    func test_FetchMemberListWithLoan_SuccessFlow() async {
        let store = TestStore(initialState: LoanReturned.State(admin: .mock)) {
            LoanReturned()
        } withDependencies: {
            $0.userApiClient.fetchAllMembersWithLoan = { return [.mock] }
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
    
    func test_FetchMemberListWithLoan_ErrorFlow() async {
        struct SomeError: Error, Equatable { }
        let store = TestStore(initialState: LoanReturned.State(admin: .mock)) {
            LoanReturned()
        } withDependencies: {
            $0.userApiClient.fetchAllMembersWithLoan = { throw SomeError() }
        }
        
        await store.send(.onAppear) {
            $0.isLoading = true
        }
        
        await store.receive(\.membersListResponse.failure) {
            $0.isLoading = false
            $0.destination = .alert(.onError(SomeError()))
        }
    }
    
    func test_LoanReturned_SuccessFlow() async {
        let store = TestStore(initialState: LoanReturned.State(admin: .mock)) {
            LoanReturned()
        } withDependencies: {
            $0.userApiClient.loanReturned = { _, _, _ in Void() }
        }
        
        await store.send(.set(\.amount, "500")) {
            $0.amount = "500"
        }
        
        await store.send(.set(\.memberSelect.selectedMembers, [.mock])) {
            $0.memberSelect.selectedMembers = [.mock]
        }
        
        await store.send(.loanReturnedTapped) {
            $0.isLoading = true
        }
        
        await store.receive(\.loanReturnedResponse.success) {
            $0.isLoading = false
            $0.amount = ""
            $0.destination = .alert(.onUpdateSuccessful())
        }
    }
    
    func test_LoanReturned_FailureFlow() async {
        struct SomeError: Error, Equatable { }
        let store = TestStore(initialState: LoanReturned.State(admin: .mock)) {
            LoanReturned()
        } withDependencies: {
            $0.userApiClient.loanReturned = { _, _, _ in throw SomeError() }
        }
        
        await store.send(.set(\.amount, "500")) {
            $0.amount = "500"
        }
        
        await store.send(.set(\.memberSelect.selectedMembers, [.mock])) {
            $0.memberSelect.selectedMembers = [.mock]
        }
        
        await store.send(.loanReturnedTapped) {
            $0.isLoading = true
        }
        
        await store.receive(\.loanReturnedResponse.failure) {
            $0.isLoading = false
            $0.destination = .alert(.onError(SomeError()))
        }
    }
}
