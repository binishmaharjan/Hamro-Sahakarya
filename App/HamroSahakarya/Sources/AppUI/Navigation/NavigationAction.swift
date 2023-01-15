import Foundation

public enum NavigationAction<ViewType>: Equatable where ViewType: Equatable {
    case present(view: ViewType)
    case presented(view: ViewType)
}
