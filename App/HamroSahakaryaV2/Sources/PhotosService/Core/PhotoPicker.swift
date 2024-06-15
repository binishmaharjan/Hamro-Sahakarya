import Foundation
import UIKit
import ComposableArchitecture
import Photos

@Reducer
public struct PhotoPicker {
    @ObservableState @dynamicMemberLookup
    public struct State: Equatable {
        public init() { }
        
        public subscript<T>(dynamicMember keyPath: KeyPath<PhotosFetchResult , T>) -> T {
            return assets[keyPath: keyPath]
        }
        
        public var authorizationStatus: AuthorizationStatus = .notDetermined
        public var assets: PhotosFetchResult = .init()
        public var selectedImageIndex: Int? = nil
    }
    
    public enum Action {
        @CasePathable public enum Delegate: Equatable {
            case imageSelected(Data?)
            case imageDeselected
        }

        case delegate(Delegate)
        case onAppear
        case saveAuthorizationStatus(AuthorizationStatus)
        case loadPhotos
        case savePhotoResponse(PhotosFetchResult)
        case openSettingsButtonTapped
        case imageSelected(at: Int)
    }
    
    public init() { }
    
    @Dependency(\.photosClient) private var photoClient
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    let status = await photoClient.requestAuthorization()
                    await send(.saveAuthorizationStatus(status))
                }
                
            case .saveAuthorizationStatus(let status):
                state.authorizationStatus = status
                guard status.isAuthorized else { return .none }
                return .send(.loadPhotos)
                
            case .loadPhotos:
                return .run { send in
                    let assets = photoClient.loadPhotos()
                    await send(.savePhotoResponse(assets))
                }
                
            case .savePhotoResponse(let assets):
                state.assets = assets
                return .none
                
            case .openSettingsButtonTapped:
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return .none }
                UIApplication.shared.open(url)
                return .none

            case .imageSelected(let index):
                if let selectedImageIndex = state.selectedImageIndex, selectedImageIndex == index {
                    state.selectedImageIndex = nil
                    return .run { send in
                        await send(.delegate(.imageDeselected))
                    }
                } else {
                    state.selectedImageIndex = index
                    return .run { [assets = state.assets] send in
                        let imageData = assets.fetchImageData(imageType: .original, index: index)
                        await send(.delegate(.imageSelected(imageData)))
                    }
                }

            case .delegate:
                return .none
            }
        }
    }
}
