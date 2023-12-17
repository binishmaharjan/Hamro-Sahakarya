import ComposableArchitecture
import XCTest

@testable import AppFeatureV2

@MainActor
final class RootTests: XCTestCase {
    
    func test_InitialState_Is_Launch() async {
        let store = TestStore(initialState: Root.State()) {
            Root()
        }
        
        let launchState = Launch.State()
        XCTAssertEqual(store.state.destination, Root.Destination.State.launch(launchState))
    }
}
