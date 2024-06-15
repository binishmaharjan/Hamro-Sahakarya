import ComposableArchitecture
import SharedModels
import XCTest

@testable import ProfileFeatureV2

@MainActor
final class ChangeMemberStatusTests: XCTestCase {
    func test_FetchMemberList_OnFirstAppear() async {
        let store = TestStore(initialState: ChangeMemberStatus.State(admin: .mock)) {
            ChangeMemberStatus()
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
        let store = TestStore(initialState: ChangeMemberStatus.State(admin: .mock)) {
            ChangeMemberStatus()
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
        let store = TestStore(initialState: ChangeMemberStatus.State(admin: .mock)) {
            ChangeMemberStatus()
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
        let store = TestStore(initialState: ChangeMemberStatus.State(admin: .mock)) {
            ChangeMemberStatus()
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
        let store = TestStore(initialState: ChangeMemberStatus.State(admin: .mock)) {
            ChangeMemberStatus()
        }
        
        await store.send(.set(\.memberSelect.selectedMembers, [.mock])) {
            $0.memberSelect.selectedMembers = [.mock]
        }
        
        XCTAssertTrue(store.state.isValidInput)
    }

    func test_ChangeMemberStatus_ShowActionProhibitedAlert() async {
        let store = TestStore(initialState: ChangeMemberStatus.State(admin: .mock)) {
            ChangeMemberStatus()
        }
        
        await store.send(.set(\.memberSelect.selectedMembers, [.mock])) {
            $0.memberSelect.selectedMembers = [.mock]
        }
        
        await store.send(.changeMemberStatusTapped) {
            $0.destination = .alert(.actionProhibited())
        }
        
        await store.send(.destination(.dismiss)) {
            $0.destination = nil
        }
    }

    func test_ChangeMemberStatus_CancelFlow() async {
        let store = TestStore(initialState: ChangeMemberStatus.State(admin: .mock2)) {
            ChangeMemberStatus()
        }

        await store.send(.set(\.memberSelect.selectedMembers, [.mock])) {
            $0.memberSelect.selectedMembers = [.mock]
        }
        
        await store.send(.changeMemberStatusTapped) {
            $0.destination = .alert(.changeMemberStatusConfirmation(currentStatus: User.mock.status))
        }
        
        await store.send(.destination(.dismiss)) {
            $0.destination = nil
        }
    }
    
    func test_ChangeMemberStatus_SuccessFlow() async {
        let store = TestStore(initialState: ChangeMemberStatus.State(admin: .mock2)) {
            ChangeMemberStatus()
        } withDependencies: {
            $0.userApiClient.changeStatus = { @Sendable _ in Void() }
            $0.userApiClient.fetchAllMembers = { return [.mock] }
        }
        
        await store.send(.set(\.memberSelect.selectedMembers, [.mock])) {
            $0.memberSelect.selectedMembers = [.mock]
        }
        
        await store.send(.changeMemberStatusTapped) {
            $0.destination = .alert(.changeMemberStatusConfirmation(currentStatus: User.mock.status))
        }
        
        await store.send(.destination(.presented(.alert(.changeConfimationTapped)))) {
            $0.destination = nil
            $0.isLoading = true
        }
        
        await store.receive(\.changeMemberStatusResponse.success) {
            $0.isStatusChanged = true
        }
        
        await store.receive(\.membersListResponse.success) {
            $0.members = [.mock]
            $0.memberSelect = .init(members: [.mock], mode: .membersOnly)
            $0.isLoading = false
            $0.isStatusChanged = false
            $0.destination = .alert(.onUpdateSuccessful())
        }
    }
    
    func test_ChangeMemberStatus_ErrorFlow() async {
        struct SomeError: Error, Equatable { }
        let store = TestStore(initialState: ChangeMemberStatus.State(admin: .mock2)) {
            ChangeMemberStatus()
        } withDependencies: {
            $0.userApiClient.changeStatus = { @Sendable _ in throw SomeError() }
        }
        
        await store.send(.set(\.memberSelect.selectedMembers, [.mock])) {
            $0.memberSelect.selectedMembers = [.mock]
        }
        
        await store.send(.changeMemberStatusTapped) {
            $0.destination = .alert(.changeMemberStatusConfirmation(currentStatus: User.mock.status))
        }
        
        await store.send(.destination(.presented(.alert(.changeConfimationTapped)))) {
            $0.destination = nil
            $0.isLoading = true
        }
        
        await store.receive(\.changeMemberStatusResponse.failure) {
            $0.destination = .alert(.onError(SomeError()))
            $0.isLoading = false
        }
    }
}
