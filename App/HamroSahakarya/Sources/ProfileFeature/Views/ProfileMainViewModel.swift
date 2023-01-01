import AppUI
import Foundation
import RxSwift
import RxCocoa

public typealias ProfileMainNavigationAction = NavigationAction<ProfileMainView>

public protocol ProfileMainViewModel {
    var view: Observable<ProfileMainNavigationAction> { get }
    func navigate(to view: ProfileMainView)
    func uiPresented(profileView: ProfileMainView)
}

public struct DefaultProfileMainViewModel: ProfileMainViewModel {
    private let _view = BehaviorSubject<ProfileMainNavigationAction>(value: .present(view: .profileView))
    public var view: Observable<ProfileMainNavigationAction> { return _view.asObservable() }
}

extension DefaultProfileMainViewModel {
    public func navigate(to view: ProfileMainView) {
        _view.onNext(.present(view: view))
    }
    
    public func uiPresented(profileView: ProfileMainView) {
        _view.onNext(.presented(view: profileView))
    }
}
