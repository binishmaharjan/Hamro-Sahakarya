import Foundation
import ComposableArchitecture
import PhotosService

@Reducer
public struct ChangePicture {
    @ObservableState
    public struct State: Equatable {
        public init() { }
        
        var photoPicker: PhotoPicker.State = .init()
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
            case .photoPicker:
                return .none
            }
        }
    }
}
