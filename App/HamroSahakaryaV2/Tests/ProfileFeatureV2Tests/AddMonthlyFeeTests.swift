import ComposableArchitecture
import XCTest

@testable import ProfileFeatureV2

@MainActor
final class AddMonthlyFeeTests: XCTestCase {
    func test_FetchMemberList_OnFirstAppear() async {
        let store = TestStore(initialState: AddMonthlyFee.State(admin: .mock)) {
            AddMonthlyFee()
        } withDependencies: {
            $0.userApiClient.fetchAllMembers = { return [.mock] }
        }
        
        await store.send(.onAppear) {
            $0.isLoading = true
        }
        
        await store.receive(\.membersListResponse.success) {
            $0.isLoading = false
            $0.members = [.mock]
            $0.memberSelect = .init(members: [.mock], mode: .all)
        }
    }
    
    func test_FetchNoMemberList_OnSecondAppear() async {
        let store = TestStore(initialState: AddMonthlyFee.State(admin: .mock)) {
            AddMonthlyFee()
        } withDependencies: {
            $0.userApiClient.fetchAllMembers = { return [.mock] }
        }
        
        await store.send(.onAppear) {
            $0.isLoading = true
        }
        
        await store.receive(\.membersListResponse.success) {
            $0.isLoading = false
            $0.members = [.mock]
            $0.memberSelect = .init(members: [.mock], mode: .all)
        }
        
        await store.send(.onAppear)
    }
    
    func test_FetchMemberList_SuccessFlow() async {
        let store = TestStore(initialState: AddMonthlyFee.State(admin: .mock)) {
            AddMonthlyFee()
        } withDependencies: {
            $0.userApiClient.fetchAllMembers = { return [.mock] }
        }
        
        await store.send(.onAppear) {
            $0.isLoading = true
        }
        
        await store.receive(\.membersListResponse.success) {
            $0.isLoading = false
            $0.members = [.mock]
            $0.memberSelect = .init(members: [.mock], mode: .all)
        }
    }
    
    func test_FetchMemberList_ErrorFlow() async {
        struct SomeError: Error, Equatable { }
        let store = TestStore(initialState: AddMonthlyFee.State(admin: .mock)) {
            AddMonthlyFee()
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
    
    func test_AddMonthlyFee_SuccessFlow() async {
        let store = TestStore(initialState: AddMonthlyFee.State(admin: .mock)) {
            AddMonthlyFee()
        } withDependencies: {
            $0.userApiClient.addMonthlyFee = { _, _, _ in Void() }
        }
        
        await store.send(.set(\.amount, "500")) {
            $0.amount = "500"
        }
        
        await store.send(.addMonthlyFeeTapped) {
            $0.isLoading = true
        }
        
        await store.receive(\.addMonthlyResponse.success) {
            $0.isLoading = false
            $0.amount = ""
            $0.destination = .alert(.onUpdateSuccessful())
        }
    }
    
    func test_AddMonthlyFee_ErrorFlow() async {
        struct SomeError: Error, Equatable { }
        let store = TestStore(initialState: AddMonthlyFee.State(admin: .mock)) {
            AddMonthlyFee()
        } withDependencies: {
            $0.userApiClient.addMonthlyFee = { _, _, _ in throw SomeError() }
        }
        
        await store.send(.set(\.amount, "500")) {
            $0.amount = "500"
        }
        
        await store.send(.set(\.members, [.mock, .mock2])) {
            $0.members = [.mock, .mock2]
        }
        
        await store.send(.addMonthlyFeeTapped) {
            $0.isLoading = true
        }
        
        await store.receive(\.addMonthlyResponse.failure) {
            $0.isLoading = false
            $0.destination = .alert(.onError(SomeError()))
        }
    }
}



















