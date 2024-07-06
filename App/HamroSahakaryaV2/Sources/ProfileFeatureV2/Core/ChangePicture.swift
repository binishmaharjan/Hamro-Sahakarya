import Foundation
import ComposableArchitecture
import PhotosService
import SharedModels
import UIKit

@Reducer
public struct ChangePicture {
    @Reducer(state: .equatable)
    public enum Destination {
        case alert(AlertState<Alert>)
        
        public enum Alert: Equatable { }
    }

    @ObservableState
    public struct State: Equatable {
        public init(user: User) {
            self.user = user
        }
        
        @Presents var destination: Destination.State?
        var user: User
        var photoPicker: PhotoPicker.State = .init()
        var imageData: Data?
        var isButtonEnabled: Bool { imageData != nil }
        var isLoading: Bool = false
    }
    
    public enum Action {
        public enum Delegate: Equatable {
            case changeImageSuccessful
        }
        
        case destination(PresentationAction<Destination.Action>)
        case delegate(Delegate)
        
        case photoPicker(PhotoPicker.Action)
        case saveButtonTapped(UIImage)
        case changeProfileImageResponse(Result<Void, Error>)
    }
    
    public init() { }
    
    @Dependency(\.userApiClient) var userApiClient
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.photoPicker, action: \.photoPicker) {
            PhotoPicker()
        }
        
        Reduce<State, Action> { state, action in
            switch action {
            case .photoPicker(.delegate(.imageSelected(let imageData))):
                state.imageData = imageData
                return .none

            case .photoPicker(.delegate(.imageDeselected)):
                state.imageData = nil
                return .none

            case .saveButtonTapped(let image):
                state.isLoading = true
                return .run { [state = state] send in
                    await send(
                        .changeProfileImageResponse(
                            Result {
                                return try await userApiClient.changeProfileImage(
                                    for: state.user,
                                    image: image
                                )
                            }
                        )
                    )
                }

            case .changeProfileImageResponse(.success):
                state.isLoading = false
                state.imageData = nil
                state.photoPicker.selectedImageIndex = nil
                state.destination = .alert(.onUpdateSuccessful())
                return .send(.delegate(.changeImageSuccessful))

            case .changeProfileImageResponse(.failure(let error)):
                state.isLoading = false
                state.destination = .alert(.onError(error))
                return .none

            case .photoPicker, .destination, .delegate:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}
