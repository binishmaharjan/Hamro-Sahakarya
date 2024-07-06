import ComposableArchitecture
import XCTest

@testable import ProfileFeatureV2

@MainActor
final class RemoveMemberTests: XCTestCase {
    func test_FetchMemberList_OnFirstAppear() async {
        let store = TestStore(initialState: RemoveMember.State(admin: .mock)) {
            RemoveMember()
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
        let store = TestStore(initialState: RemoveMember.State(admin: .mock)) {
            RemoveMember()
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
        let store = TestStore(initialState: RemoveMember.State(admin: .mock)) {
            RemoveMember()
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
        let store = TestStore(initialState: RemoveMember.State(admin: .mock)) {
            RemoveMember()
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
    
    func test_IsValidInput() async {
        let store = TestStore(initialState: RemoveMember.State(admin: .mock)) {
            RemoveMember()
        }
        
        await store.send(.set(\.memberSelect.selectedMembers, [.mock])) {
            $0.memberSelect.selectedMembers = [.mock]
        }
        
        XCTAssertTrue(store.state.isValidInput)
    }
    
    func test_RemoveMember_ShowActionProhibitedAlert() async {
        let store = TestStore(initialState: RemoveMember.State(admin: .mock)) {
            RemoveMember()
        }
        
        await store.send(.set(\.memberSelect.selectedMembers, [.mock])) {
            $0.memberSelect.selectedMembers = [.mock]
        }
        
        await store.send(.removeMemberTapped) {
            $0.destination = .alert(.actionProhibited())
        }
        
        await store.send(.destination(.dismiss)) {
            $0.destination = nil
        }
    }
    
    func test_RemoveMember_CancelFlow() async {
        let store = TestStore(initialState: RemoveMember.State(admin: .mock2)) {
            RemoveMember()
        }
        
        await store.send(.set(\.memberSelect.selectedMembers, [.mock])) {
            $0.memberSelect.selectedMembers = [.mock]
        }
        
        await store.send(.removeMemberTapped) {
            $0.destination = .alert(.removeMemberConfirmation())
        }
        
        await store.send(.destination(.dismiss)) {
            $0.destination = nil
        }
    }
    
    func test_RemoveMember_SuccessFlow() async {
        let store = TestStore(initialState: RemoveMember.State(admin: .mock2)) {
            RemoveMember()
        } withDependencies: {
            $0.userApiClient.removeMember = { @Sendable _, _ in Void() }
            $0.userApiClient.fetchAllMembers = { return [.mock] }
        }
        
        await store.send(.set(\.memberSelect.selectedMembers, [.mock])) {
            $0.memberSelect.selectedMembers = [.mock]
        }
        
        await store.send(.removeMemberTapped) {
            $0.destination = .alert(.removeMemberConfirmation())
        }
        
        await store.send(.destination(.presented(.alert(.removeConfirmationTapped)))) {
            $0.destination = nil
            $0.isLoading = true
        }
        
        await store.receive(\.removeMemberResponse.success) {
            $0.isRemovingMember = true
        }
        
        await store.receive(\.membersListResponse.success) {
            $0.members = [.mock]
            $0.memberSelect = .init(members: [.mock], mode: .membersOnly)
            $0.isLoading = false
            $0.isRemovingMember = false
            $0.destination = .alert(.onMemberRemoved())
        }
    }
    
    func test_RemoveMember_ErrorFlow() async {
        struct SomeError: Error, Equatable { }
        let store = TestStore(initialState: RemoveMember.State(admin: .mock2)) {
            RemoveMember()
        } withDependencies: {
            $0.userApiClient.removeMember = { @Sendable _, _ in throw SomeError() }
        }
        
        await store.send(.set(\.memberSelect.selectedMembers, [.mock])) {
            $0.memberSelect.selectedMembers = [.mock]
        }
        
        await store.send(.removeMemberTapped) {
            $0.destination = .alert(.removeMemberConfirmation())
        }
        
        await store.send(.destination(.presented(.alert(.removeConfirmationTapped)))) {
            $0.destination = nil
            $0.isLoading = true
        }
        
        await store.receive(\.removeMemberResponse.failure) {
            $0.destination = .alert(.onError(SomeError()))
            $0.isLoading = false
        }
    }
}
