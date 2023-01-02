import Foundation
import RxCocoa
import RxSwift

public struct SignedInViewModel {
    private let viewSubject = BehaviorRelay<SignedInView>(value: .tabbar)
    public var view: Observable<SignedInView> {
        return viewSubject.asObservable()
    }
}
