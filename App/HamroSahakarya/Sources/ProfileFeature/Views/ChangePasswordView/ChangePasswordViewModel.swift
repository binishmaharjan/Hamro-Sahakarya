import AppUI
import Core
import Foundation
import RxCocoa
import RxSwift

public protocol ChangePasswordStateProtocol {
    var passwordText: String { get }
    var confirmPasswordText: String { get }
}

extension ChangePasswordStateProtocol {
    public var isPasswordTextValid: Bool {
        return passwordText.count > 5
    }
    
    public var isConfirmPasswordTextValid: Bool {
        return confirmPasswordText.count > 5
    }
    
    public var isChangePasswordButtonEnabled: Bool {
        return isPasswordTextValid && isConfirmPasswordTextValid
    }
}

public protocol ChangePasswordViewModel {
    var passwordInput: BehaviorRelay<String> { get }
    var confirmPasswordInput: BehaviorRelay<String> { get }
    var isChangePasswordButtonEnabled: Observable<Bool> { get }
    var apiState: Driver<State> { get }
    
    func changePassword()
    func signOut()
}

public struct DefaultChangePasswordViewModel: ChangePasswordViewModel {
    public struct UIState: ChangePasswordStateProtocol {
        public var passwordText: String
        public var confirmPasswordText: String
    }
    
    private let userSessionRepository: UserSessionRepository
    private let userSession: UserSession
    private let notSignedInResponder: NotSignedInResponder
    
    public let passwordInput = BehaviorRelay<String>(value: "")
    public let confirmPasswordInput = BehaviorRelay<String>(value: "")
    public let isChangePasswordButtonEnabled: Observable<Bool>
    @PropertyBehaviorRelay<State>(value: .idle)
    public var apiState: Driver<State>
    
    public init(
        userSessionRepository: UserSessionRepository,
        userSession: UserSession, notSignedInResponder: NotSignedInResponder
    ) {
        self.userSessionRepository = userSessionRepository
        self.userSession = userSession
        self.notSignedInResponder = notSignedInResponder
        
        let state = Observable.combineLatest(passwordInput, confirmPasswordInput) { UIState(passwordText: $0, confirmPasswordText: $1) }
        isChangePasswordButtonEnabled = state.map{ $0.isChangePasswordButtonEnabled }
    }

    private func validatePassword() -> Bool {
        let password = passwordInput.value
        let confirmPassword = confirmPasswordInput.value
        return password.elementsEqual(confirmPassword)
    }
    
    public func changePassword()  {
        indicateLoading()
        
        guard validatePassword() else {
            indicateError(error: HSError.passwordDoesntMatch)
            return
        }
        
        userSessionRepository
            .changePassword(userSession: userSession, newPassword: passwordInput.value)
            .done(indicateSuccess(newPassword:)).catch(indicateError(error:))
    }
    
    public func signOut() {
        notSignedInResponder.notSignedIn()
    }
}

extension DefaultChangePasswordViewModel {
    private func indicateLoading() {
        _apiState.accept(.loading)
    }
    
    private func indicateSuccess(newPassword: String) {
        _apiState.accept(.completed)
    }
    
    private func indicateError(error: Error) {
        _apiState.accept(.error(error))
    }
}
