import AppUI
import Core
import Foundation
import RxCocoa
import RxSwift

public enum SignInEvent {
    case showRegister
    case signInTapped
    case none
}

public protocol SignInStateProtocol {
    var emailText: String { get }
    var passwordText: String { get }
}

extension SignInStateProtocol {
    public var isEmailValid: Bool {
        return emailText.contains("@") && emailText.contains(".")
    }
    
    public var isPasswordValid: Bool {
        return passwordText.count > 5
    }
    
    public var isSignInEnabled: Bool {
        return isEmailValid && isPasswordValid
    }
}

public struct SignInViewModel {
    public struct UIState: SignInStateProtocol {
        public var emailText: String
        public var passwordText: String
    }
    
    // MARK: Properties
    private let userSessionRepository: UserSessionRepository
    private let signedInResponder: SignedInResponder
    private let signUpNavigator: GoToSignUpNavigator
    
    let emailInput = BehaviorSubject<String>(value: "")
    let passwordInput = BehaviorSubject<String>(value: "")
    
    public let isSignInEnabled: Observable<Bool>
    
    @PropertyBehaviorRelay<State>(value: .idle)
    var apiState: Driver<State>
    
    @PropertyPublishSubject(value: SignInEvent.none)
    var event: Observable<SignInEvent>
    
    /// user double tapped in the screen
    var doubleTapGesture: Binder<Void> {
        return Binder(_event) { observer, _  in
            observer.onNext(SignInEvent.showRegister)
        }
    }
    /// User Pressed Sign in Button
    var signInButtonTapped: Binder<Void> {
        return Binder(_event) { observer, _ in
            observer.onNext(SignInEvent.signInTapped)
        }
    }
    
    private let errorMessageSubject = PublishSubject<ErrorMessage>()
    var errorMessage: Observable<ErrorMessage> {
        return errorMessageSubject.asObserver()
    }
    
    // MARK: Init
    public init(
        userSessionRepository: UserSessionRepository,
        signedInResponder: SignedInResponder,
        signUpNavigator: GoToSignUpNavigator
    ) {
        self.userSessionRepository = userSessionRepository
        self.signedInResponder = signedInResponder
        self.signUpNavigator = signUpNavigator

        let state = Observable.combineLatest(emailInput, passwordInput) { UIState(emailText: $0, passwordText: $1) }
        isSignInEnabled = state.map { $0.isSignInEnabled }
    }
    
    // MARK: Methods
    
    /// Sign in with current email and password
    ///
    /// Returns: Void
    func signIn() {
        indicateSigningIn()
        let (email, password) = getEmailAndPassword()
        userSessionRepository.signIn(email: email, password: password)
            .done(indicateSignInSuccessful(userSession:))
            .catch(indicateErrorSigningIn)
    }
    
    /// Navigate To Sign Up View
    ///
    /// Returns: Void
    func showSignUpView() {
        signUpNavigator.navigateToSignUp()
    }
    
    private func getEmailAndPassword() -> (String, String) {
        do {
            return try (emailInput.value(), passwordInput.value())
        } catch {
            fatalError("Error Reading Text Field Values")
        }
    }
    
}

// MARK: SignIn Indication
extension SignInViewModel {
    private func indicateSigningIn() {
        _apiState.accept(.loading)
    }
    
    private func indicateSignInSuccessful(userSession: UserSession) {
        _apiState.accept(.completed)
        signedInResponder.signedIn(to: userSession)
    }
    
    private func indicateErrorSigningIn(_ error: Error) {
        let errorMessage = ErrorMessage(title: "Sign In Failed.", message: error.localizedDescription)
        errorMessageSubject.onNext(errorMessage)
        
        _apiState.accept(.error(error))
    }
}

