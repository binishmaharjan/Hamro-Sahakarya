import AppUI
import Core
import Foundation
import RxSwift

public struct LaunchViewModel {
    // MARK: Properties
    private let userSessionRepository: UserSessionRepository
    private let notSignedInResponder: NotSignedInResponder
    private let signedInResponder: SignedInResponder
    
    private var errorMessageSubject: PublishSubject<ErrorMessage> = PublishSubject()
    public var errorMessage: Observable<ErrorMessage> {
        return errorMessageSubject.asObserver()
    }
    
    public let errorPresentation: BehaviorSubject<ErrorPresentation?> = BehaviorSubject(value: nil)
    
    // MARK: Init
    public init(
        userSessionRepository: UserSessionRepository,
        notSignedInResponder: NotSignedInResponder,
        signedInResponder: SignedInResponder
    ) {
        self.userSessionRepository = userSessionRepository
        self.signedInResponder = signedInResponder
        self.notSignedInResponder = notSignedInResponder
    }
    
    // TODO: Change To Proper Error Message
    public func loadUserSession() {
        userSessionRepository.readUserSession()
            .done(goToNextScreen(userSession:))
            .catch{ error in
                let errorMessage = ErrorMessage(title: "Sign In Error",
                                                message: "Sorry, we couldn't determine if you are already signed in. Please sign in or sign up.")
                self.present(errorMessage: errorMessage)
            }
    }
    
    public func present(errorMessage: ErrorMessage) {
        goToNextScreenAfterErrorPresentation()
        errorMessageSubject.onNext(errorMessage)
    }
    
    public func goToNextScreenAfterErrorPresentation() {
        _ = errorPresentation.filter { $0 == .dismissed }
            .take(1)
            .subscribe(onNext: { _ in
                self.goToNextScreen(userSession: nil)
            })
    }
    
    public func goToNextScreen(userSession: UserSession?) {
        switch userSession {
        case .none:
            notSignedInResponder.notSignedIn()
        case let .some(userSession):
            signedInResponder.signedIn(to: userSession)
        }
    }
}
