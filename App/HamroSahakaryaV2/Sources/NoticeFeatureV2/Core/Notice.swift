import Foundation
import ComposableArchitecture
import SharedModels

@Reducer
public struct Notice {
    @ObservableState
    public struct State: Equatable {
        public init(notice: NoticeInfo) {
            self.notice = notice
        }
        
        public var notice: NoticeInfo
    }
    
    public enum Action {
        case doNotShowAgainChecked
        case okButtonTapped
    }
    
    public init() { }
    
    @Dependency(\.dismiss) private var dismiss
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .doNotShowAgainChecked:
                return .none
                
            case .okButtonTapped:
                return .run { _ in
                    await dismiss()
                }
            }
        }
    }
}
