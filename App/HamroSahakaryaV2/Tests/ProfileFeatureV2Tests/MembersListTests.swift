import ComposableArchitecture
import XCTest

@testable import ProfileFeatureV2

@MainActor
final class MembersListTests: XCTestCase {
    func test_FetchMembers_OnAppear() async {
        let store = TestStore(initialState: MembersList.State()) {
            MembersList()
        } withDependencies: {
            $0.userApiClient.fetchAllMembers = { return [] }
        }
        
        store.exhaustivity = .off
        
        await store.send(.onAppear)
        
        await store.receive(.fetchMembersList)
    }
    
    func test_FetchMembers_SuccessFlow() async {
        let store = TestStore(initialState: MembersList.State()) {
            MembersList()
        } withDependencies: {
            $0.userApiClient.fetchAllMembers = { return [.mock] }
        }
        
        await store.send(.onAppear)
        await store.receive(.fetchMembersList) {
            $0.isLoading = true
        }
        
        await store.receive(.membersListResponse(.success([.mock]))) {
            $0.isLoading = false
            $0.members = [.mock]
        }
    }
    
    func test_FetchMembers_ErrorFlow() async {
        struct SomeError: Error, Equatable { }
        let store = TestStore(initialState: MembersList.State()) {
            MembersList()
        } withDependencies: {
            $0.userApiClient.fetchAllMembers = { throw SomeError() }
        }
        
        await store.send(.onAppear)
        await store.receive(.fetchMembersList) {
            $0.isLoading = true
        }
        
        await store.receive(\.membersListResponse.failure) {
            $0.isLoading = false
            $0.destination = .alert(.fetchLMembersListFailed(SomeError()))
        }
        
        await store.send(.destination(.dismiss)) {
            $0.destination = nil
        }
    }
}
