import Foundation
import ComposableArchitecture
import PhotosService

@Reducer
public struct ChangePicture {
    @ObservableState
    public struct State: Equatable {
        public init() { }
        
        var photoPicker: PhotoPicker.State = .init()
        var imageData: Data?
    }
    
    public enum Action{
        case photoPicker(PhotoPicker.Action)
    }
    
    public init() { }
    
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
                return .none

            case .photoPicker:
                return .none
            }
        }
    }
}
