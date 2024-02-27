import ComposableArchitecture
import XCTest

@testable import ProfileFeatureV2

@MainActor
final class MembersSelectTests: XCTestCase {
    func test_AllMember_Selected_OnAppear() async {
        let state = MemberSelect.State(members: [.mock, .mock2])
        let store = TestStore(initialState: state) {
            MemberSelect()
        }
        
        XCTAssertEqual(store.state.selectedMembers, [])
    }
    
    func test_Member_Selected_OnTap() async {
        let state = MemberSelect.State(members: [.mock, .mock2])
        let store = TestStore(initialState: state) {
            MemberSelect()
        }
        
        await store.send(.rowSelected(.member(.mock))) {
            $0.selectedMembers = [.mock]
        }
        
        await store.send(.rowSelected(.member(.mock2))) {
            $0.selectedMembers = [.mock, .mock2]
        }
    }
    
    func test_Member_Deselected_OnSecondTap() async {
        let state = MemberSelect.State(members: [.mock, .mock2])
        let store = TestStore(initialState: state) {
            MemberSelect()
        }
        
        await store.send(.rowSelected(.member(.mock))) {
            $0.selectedMembers = [.mock]
        }
        
        await store.send(.rowSelected(.member(.mock))) {
            $0.selectedMembers = []
        }
    }
    
    func test_Reset_WhenAll_IsTapped() async {
        let state = MemberSelect.State(members: [.mock, .mock2])
        let store = TestStore(initialState: state) {
            MemberSelect()
        }
        
        await store.send(.rowSelected(.member(.mock))) {
            $0.selectedMembers = [.mock]
        }
        
        await store.send(.rowSelected(.member(.mock2))) {
            $0.selectedMembers = [.mock, .mock2]
        }
        
        await store.send(.rowSelected(.all)) {
            $0.selectedMembers = []
        }
    }
}
