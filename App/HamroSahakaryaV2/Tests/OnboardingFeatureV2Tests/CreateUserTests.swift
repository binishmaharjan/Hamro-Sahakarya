import ComposableArchitecture
import XCTest
import SharedModels
import SharedUIs

@testable import OnboardingFeatureV2
@testable import ColorPaletteFeatureV2

@MainActor
final class CreateUserTests: XCTestCase {
    
    func test_IsValidInput() async {
        let store = TestStore(initialState: CreateUser.State()) {
            CreateUser()
        }
        
        await store.send(.set(\.email, "a@b.com")) {
            $0.email = "a@b.com"
        }
        XCTAssertFalse(store.state.isValidInput)
        
        await store.send(.set(\.fullname, "ab")) {
            $0.fullname = "ab"
        }
        XCTAssertFalse(store.state.isValidInput)
        
        await store.send(.set(\.password, "password")) {
            $0.password = "password"
        }
        XCTAssertTrue(store.state.isValidInput)
    }
    
    func test_MemberStatusChanged() async {
        let store = TestStore(initialState: CreateUser.State()) {
            CreateUser()
        }
        
        XCTAssertEqual(store.state.status, .member)
        
        await store.send(.memberFieldTapped) {
            $0.destination = .confirmationDialog(.selectStatus)
        }
        
        await store.send(.destination(.presented(.confirmationDialog(.presented(.adminTapped))))) {
            $0.destination = nil
            $0.status = .admin
        }
        
        await store.send(.memberFieldTapped) {
            $0.destination = .confirmationDialog(.selectStatus)
        }
        
        await store.send(.destination(.presented(.confirmationDialog(.presented(.memberTapped))))) {
            $0.destination = nil
            $0.status = .member
        }
    }
    
    func test_ColorSelected() async {
        let store = TestStore(initialState: CreateUser.State()) {
            CreateUser()
        }
        
        XCTAssertEqual(store.state.colorHex, "#F77D8E")
        
        await store.send(.colorPickerFieldTapped) {
            $0.destination = .colorPicker(.init())
        }
        
        var colorPaletteState = ColorPalette.State()
        var colorPickerState = ColorPicker.State()
        
        
        // Step 1: When color is selected in ColorPaletteView, Color Palette State Changes
        await store.send(.destination(.presented(.colorPicker(.colorPalette(.viewTappedOn("#FFFFFF")))))) {
            colorPaletteState.selectedColorHex = "#FFFFFF"
            colorPickerState.colorPalette = colorPaletteState
            
            $0.destination = .colorPicker(colorPickerState)
        }
        
        // Step 2: Delegate Action is send towards the ColorPicker Reducer, and ColorPicker State is changed
        await store.receive(.destination(.presented(.colorPicker(.colorPalette(.delegate(.colorSelected("#FFFFFF"))))))) {
            colorPickerState.colorHex = "#FFFFFF"
            
            $0.destination = .colorPicker(colorPickerState)
        }
        
        // Step 3: Select button is pressed in the ColorPickerView
        await store.send(.destination(.presented(.colorPicker(.selectButtonTapped))))
        
        // Step 4: Delegate Action is send toward the CreateUser Reducer, and CreateUser State is changed
        await store.receive(.destination(.presented(.colorPicker(.delegate(.colorSelected("#FFFFFF")))))) {
            $0.destination = nil
            $0.colorHex = "#FFFFFF"
        }
    }
    
    func test_CreateUser_SuccessFlow() async {
        let store = TestStore(initialState: CreateUser.State()) {
            CreateUser()
        } withDependencies: {
            $0.userApiClient.createUser = { _ in .mock }
        }
        
        await store.send(.createUserButtonTapped) {
            $0.isLoading = true
        }
        
        await store.receive(.createUserResponse(.success(.mock))) {
            $0.isLoading = false
        }
        
        await store.receive(.delegate(.createAccountSuccessful(.mock)))
    }
    
    func test_CreateUser_ErrorFlow() async {
        struct SomeError: Error, Equatable {}
        let store = TestStore(initialState: CreateUser.State()) {
            CreateUser()
        } withDependencies: {
            $0.userApiClient.createUser = { _ in throw SomeError() }
        }
        
        await store.send(.createUserButtonTapped) {
            $0.isLoading = true
        }
        
        await store.receive(\.createUserResponse.failure) {
            $0.isLoading = false
            $0.destination = .alert(
                AlertState<CreateUser.Destination.Action.Alert> {
                    TextState(#localized("Error"))
                } actions: {
                    ButtonState { TextState(#localized("Ok")) }
                } message: {
                    TextState(SomeError().localizedDescription)
                }
            )
        }
        
        await store.send(.destination(.dismiss)) {
            $0.destination = nil
        }
    }
}
