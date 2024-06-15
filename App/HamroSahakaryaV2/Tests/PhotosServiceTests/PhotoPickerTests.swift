import ComposableArchitecture
import XCTest

@testable import PhotosService

@MainActor
final class PhotoPickerTests: XCTestCase {
    func test_OnAppear_LoadNoPhotos_IfNotAuthorized() async {
        let store = TestStore(initialState: PhotoPicker.State()) {
            PhotoPicker()
        } withDependencies: {
            $0.photosClient.requestAuthorization = { return .denied }
        }
        store.exhaustivity = .off
        await store.send(.onAppear)
        await store.receive(\.saveAuthorizationStatus) {
            $0.authorizationStatus = .denied
        }
    }

    func test_OnAppear_LoadPhotos_IfAuthorized() async {
        let store = TestStore(initialState: PhotoPicker.State()) {
            PhotoPicker()
        } withDependencies: {
            $0.photosClient.requestAuthorization = { return .authorized }
            $0.photosClient.loadPhotos = { return .init() }
        }
        store.exhaustivity = .off
        await store.send(.onAppear)
        await store.receive(\.saveAuthorizationStatus) {
            $0.authorizationStatus = .authorized
        }
        await store.receive(\.loadPhotos)
    }
}
