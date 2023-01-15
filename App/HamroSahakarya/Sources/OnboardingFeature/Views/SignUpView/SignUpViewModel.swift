import AppUI
import Core
import Foundation
import RxCocoa
import RxSwift

public enum SignUpEvent {
    case signUpButtonTapped
    case backButtonTapped
    case colorViewTapped
    case statusLabelTapped
}

public protocol SignUpStateProtocol {
    var emailText: String { get }
    var fullNameText: String { get }
    var passwordText: String { get }
    var colorText: String { get }
}

extension SignUpStateProtocol {
    private var isEmailValid: Bool {
        return emailText.contains("@") && emailText.contains(".")
    }
    
    public var isFullNameValid: Bool {
        return fullNameText.contains(" ")
    }
    
    public var isPasswordValid: Bool {
        return passwordText.count > 5
    }
    
    public var isColorValid: Bool {
        return !colorText.isEmpty
    }
    
    public var isSignUpValid: Bool {
        return isEmailValid && isFullNameValid && isPasswordValid && isColorValid
    }
}

public struct SignUpViewModel {
    public struct UIState: SignUpStateProtocol {
        public var emailText: String
        public var fullNameText: String
        public var passwordText: String
        public var colorText: String
    }
    
    // MARK: Properties
    private let userSessionRepository: UserSessionRepository
    private let signedInResponder: SignedInResponder
    
    let emailInput = BehaviorRelay<String>(value: "")
    let passwordInput = BehaviorRelay<String>(value: "")
    let fullNameInput = BehaviorRelay<String>(value: "")
    let initialAmountInput = BehaviorRelay<Int>(value: 0)
    let statusInput = BehaviorRelay<Status>(value: .member)
    let colorInput = BehaviorRelay<String>(value: "")
    let isSignUpValid: Observable<Bool>
    
    @PropertyBehaviorRelay<State>(value: .idle)
    var apiState: Driver<State>
    
    private let eventSubject = PublishSubject<SignUpEvent>()
    var event: Observable<SignUpEvent> { return eventSubject.asObservable() }
    
    /// Sign Up Button Was Pressed``
    var signUpButtonTapped: Binder<Void> {
        return Binder(eventSubject) { observer, _ in
            observer.onNext(.signUpButtonTapped)
        }
    }
    
    var backButtonTapped: Binder<Void> {
        return Binder(eventSubject) { observer, _ in
            observer.onNext(.backButtonTapped)
        }
    }
    
    var colorViewTapped: Binder<Void> {
        return Binder(eventSubject) { observer, _ in
            observer.onNext(.colorViewTapped)
        }
    }
    
    var statusLabelTapped: Binder<Void> {
        return Binder(eventSubject) { observer, _ in
            observer.onNext(.statusLabelTapped)
        }
    }

    // MARK: Init
    public init(
        userSessionRepository: UserSessionRepository,
        signedInResponder: SignedInResponder
    ) {
        self.userSessionRepository = userSessionRepository
        self.signedInResponder = signedInResponder
        
        let state = Observable.combineLatest(emailInput, fullNameInput, passwordInput, colorInput) {
            UIState(emailText: $0, fullNameText: $1, passwordText: $2, colorText: $3)
        }
        
        isSignUpValid = state.map { $0.isSignUpValid }
    }
    
    
    func signUp() {
        indicateSigningUp()
        userSessionRepository.signUp(newAccount: getNewAccount())
            .done(indicateSignUpSuccessful(userSession:))
            .catch(indicateErrorSigningUp)
    }
    
    private func getNewAccount() -> NewAccount {
        let email = emailInput.value
        let password = passwordInput.value
        let fullName = fullNameInput.value
        let initialAmount = initialAmountInput.value
        let status = statusInput.value
        let color = colorInput.value
        let newAccount = NewAccount(username: fullName,
                                    email: email,
                                    status: status,
                                    colorHex: color,
                                    dateCreated: Date().toString,
                                    keyword: password,
                                    initialAmount: initialAmount)
        return newAccount
    }
}

// MARK: SignUp Indication
extension SignUpViewModel {
    private func indicateSigningUp() {
        _apiState.accept(.loading)
    }
    
    private func indicateSignUpSuccessful(userSession: UserSession) {
        _apiState.accept(.completed)
        signedInResponder.signedIn(to: userSession)
    }
    
    private func indicateErrorSigningUp(_ error: Error) {
        _apiState.accept(.error(error))
    }
}
