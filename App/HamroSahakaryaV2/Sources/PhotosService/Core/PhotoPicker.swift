import Foundation
import ComposableArchitecture

@Reducer
public struct PhotoPicker {
    @ObservableState
    public struct State: Equatable {
        public init() { }
        
        var authorizationStatus: AuthorizationStatus = .notDetermined
        var assets: LoadPhotoResponse = LoadPhotoResponse()
    }
    
    public enum Action {
        case onAppear
        case saveAuthorizationStatus(AuthorizationStatus)
        case loadPhotos
        case savePhotoResponse(LoadPhotoResponse)
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
                    let assets = await photoClient.loadPhotos()
                    await send(.savePhotoResponse(assets))
                }
                
            case .savePhotoResponse(let assets):
                state.assets = assets
                print("assets.count: \(assets.count)")
                return .none
            }
        }
    }
}
