import AppUI
import Core
import Foundation
import RxSwift

// TODO: Make this struct
public final class MainViewModel {
    private let viewSubject = BehaviorSubject<MainView>(value: .launching)
    var view: Observable<MainView> { return  viewSubject.asObservable() }
    
    init() { }
}

// MARK: Set Main Child View To SignedIn View
extension MainViewModel: SignedInResponder {
    public func signedIn(to userSession: UserSession) {
        viewSubject.onNext(.signedIn(userSession: userSession))
    }
}

// MARK: Set Main Child View To Onboarding View
extension MainViewModel: NotSignedInResponder {
    public func notSignedIn() {
        viewSubject.onNext(.onboarding)
    }
}

