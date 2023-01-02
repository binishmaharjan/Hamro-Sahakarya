import AppUI
import Foundation
import RxSwift

public typealias OnboardingNavigationAction = NavigationAction<OnboardingView>

public struct OnboardingViewModel {
    private let _view = BehaviorSubject<OnboardingNavigationAction>(value: .present(view: .signIn))
    public var view: Observable<OnboardingNavigationAction> { return _view.asObservable() }

    public init() {}
}

extension OnboardingViewModel: GoToSignUpNavigator {
    public func navigateToSignUp() {
        _view.onNext(.present(view: .signUp))
    }
    
    public func uiPresented(onboardingView: OnboardingView) {
        _view.onNext(.presented(view: onboardingView))
    }
}
