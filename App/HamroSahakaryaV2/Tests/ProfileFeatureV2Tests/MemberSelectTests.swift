import ComposableArchitecture
import XCTest

@testable import ProfileFeatureV2

@MainActor
final class MembersSelectTests: XCTestCase {
    func test_AllMode_AllMember_Selected_OnInit() async {
        let state = MemberSelect.State(members: [.mock, .mock2], mode: .all)
        let store = TestStore(initialState: state) {
            MemberSelect()
        }
        
        XCTAssertEqual(store.state.selectedMembers, [])
    }
    
    func test_MemberMode_FirstMember_Selected_OnInit() async {
        let state = MemberSelect.State(members: [.mock, .mock2], mode: .membersOnly)
        let store = TestStore(initialState: state) {
            MemberSelect()
        }
        
        XCTAssertEqual(store.state.selectedMembers, [.mock])
    }
    
    func test_AllMode_Member_Selected_OnTap() async {
        let state = MemberSelect.State(members: [.mock, .mock2], mode: .all)
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
    
    func test_MemberMode_Member_Selected_OnTap() async {
        let state = MemberSelect.State(members: [.mock, .mock2], mode: .membersOnly)
        let store = TestStore(initialState: state) {
            MemberSelect()
        }
        
        await store.send(.rowSelected(.member(.mock2))) {
            $0.selectedMembers = [.mock2]
        }
    }
    
    func test_AllMode_Member_Deselected_OnSecondTap() async {
        let state = MemberSelect.State(members: [.mock, .mock2], mode: .all)
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
    
    func test_MemberMode_Member_NotDeselected_OnSecondTap() async {
        let state = MemberSelect.State(members: [.mock, .mock2], mode: .membersOnly)
        let store = TestStore(initialState: state) {
            MemberSelect()
        }
        
        await store.send(.rowSelected(.member(.mock2))) {
            $0.selectedMembers = [.mock2]
        }
        
        await store.send(.rowSelected(.member(.mock2)))
    }
    
    func test_AllMode_Reset_When_AllIsTapped() async {
        let state = MemberSelect.State(members: [.mock, .mock2], mode: .all)
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
    
    func test_MemberMode_Deselect_Other_When_MemberIsTapped() async {
        let state = MemberSelect.State(members: [.mock, .mock2], mode: .membersOnly)
        let store = TestStore(initialState: state) {
            MemberSelect()
        }
        
        await store.send(.rowSelected(.member(.mock2))) {
            $0.selectedMembers = [.mock2]
        }
        
        await store.send(.rowSelected(.member(.mock))) {
            $0.selectedMembers = [.mock]
        }
    }
}
