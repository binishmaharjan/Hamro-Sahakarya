import ComposableArchitecture
import XCTest

@testable import ProfileFeatureV2

@MainActor
final class LoanMemberTests: XCTestCase {
    func test_FetchMemberList_OnFirstAppear() async {
        let store = TestStore(initialState: LoanMember.State(admin: .mock)) {
            LoanMember()
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
        let store = TestStore(initialState: LoanMember.State(admin: .mock)) {
            LoanMember()
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
    
    func test_FetchMemberList_SuccessFlow() async {
        let store = TestStore(initialState: LoanMember.State(admin: .mock)) {
            LoanMember()
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
        let store = TestStore(initialState: LoanMember.State(admin: .mock)) {
            LoanMember()
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
        let store = TestStore(initialState: LoanMember.State(admin: .mock)) {
            LoanMember()
        } withDependencies: {
            $0.userApiClient.loanGiven = {@Sendable  _, _, _ in Void() }
        }
        
        await store.send(.set(\.amount, "500")) {
            $0.amount = "500"
        }
        
        await store.send(.set(\.memberSelect.selectedMembers, [.mock])) {
            $0.memberSelect.selectedMembers = [.mock]
        }
        
        await store.send(.loanMemberTapped) {
            $0.isLoading = true
        }
        
        await store.receive(\.loanMemberResponse.success) {
            $0.isLoading = false
            $0.amount = ""
            $0.destination = .alert(.onUpdateSuccessful())
        }
    }
    
    func test_LoanMember_FailureFlow() async {
        struct SomeError: Error, Equatable { }
        let store = TestStore(initialState: LoanMember.State(admin: .mock)) {
            LoanMember()
        } withDependencies: {
            $0.userApiClient.loanGiven = { @Sendable _, _, _ in throw SomeError() }
        }
        
        await store.send(.set(\.amount, "500")) {
            $0.amount = "500"
        }
        
        await store.send(.set(\.memberSelect.selectedMembers, [.mock])) {
            $0.memberSelect.selectedMembers = [.mock]
        }
        
        await store.send(.loanMemberTapped) {
            $0.isLoading = true
        }
        
        await store.receive(\.loanMemberResponse.failure) {
            $0.isLoading = false
            $0.destination = .alert(.onError(SomeError()))
        }
    }
}
