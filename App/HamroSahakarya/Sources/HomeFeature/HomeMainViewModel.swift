import AppUI
import Foundation
import RxCocoa
import RxSwift

public typealias HomeNavigationAction = NavigationAction<HomeView>

public enum HomeView {
    case home
}

public protocol HomeViewResponder {
    var view: Observable<HomeNavigationAction> { get }
}

public protocol HomeMainViewModelProtocol: HomeViewResponder {
    func navigate(to view: HomeView)
    func uiPresented(homeView: HomeView)
}

public struct HomeMainViewModel: HomeMainViewModelProtocol {
    private let _view = BehaviorSubject<HomeNavigationAction>(value: .present(view: .home))
    public var view: Observable<HomeNavigationAction> {
        return _view.asObservable()
    }

    public init() {}
    
    public func navigate(to view: HomeView) {
        _view.onNext(.present(view: view))
    }
    
    public func uiPresented(homeView: HomeView) {
        _view.onNext(.presented(view: homeView))
    }
}

