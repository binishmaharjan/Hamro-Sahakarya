//
//  ChangePasswordViewModel.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/03/07.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ChangePasswordStateProtocol {
    var passwordText: String { get }
    var confirmPassowrdText: String { get }
}

extension ChangePasswordStateProtocol {
    var isPasswordTextValid: Bool {
        return passwordText.count > 5
    }
    
    var isConfirmPasswordTextValid: Bool {
        return confirmPassowrdText.count > 5
    }
    
    var isChangePasswordButtonEnabled: Bool {
        return isPasswordTextValid && isConfirmPasswordTextValid
    }
}

protocol ChangePasswordViewModel {
    var passwordInput: BehaviorRelay<String> { get }
    var confirmPasswordInput: BehaviorRelay<String> { get }
    var isChangePasswordButtonEnabled: Observable<Bool> { get }
    var apiState: Driver<State> { get }
    
    func changePassword()
    func signOut()
}

struct DefaultChangePasswordViewModel: ChangePasswordViewModel {
    
    struct UIState: ChangePasswordStateProtocol {
        var passwordText: String
        var confirmPassowrdText: String
    }
    
    private let userSessionRepository: UserSessionRepository
    private let userSession: UserSession
    private let notSignedInResponder: NotSignedInResponder
    
    let passwordInput = BehaviorRelay<String>(value: "")
    let confirmPasswordInput = BehaviorRelay<String>(value: "")
    let isChangePasswordButtonEnabled: Observable<Bool>
    @PropertyBehaviourRelay<State>(value: .idle)
    var apiState: Driver<State>
    
    init(userSessionRepository: UserSessionRepository, userSession: UserSession, notSignedInResponder: NotSignedInResponder) {
        self.userSessionRepository = userSessionRepository
        self.userSession = userSession
        self.notSignedInResponder = notSignedInResponder
        
        let state = Observable.combineLatest(passwordInput, confirmPasswordInput) { UIState(passwordText: $0, confirmPassowrdText: $1) }
        isChangePasswordButtonEnabled = state.map{ $0.isChangePasswordButtonEnabled }
    }
    
    
    private func validatePassword() -> Bool {
        let password = passwordInput.value
        let confirmPassword = confirmPasswordInput.value
        return password.elementsEqual(confirmPassword)
    }
    
    func changePassword()  {
        indicateLoading()
        
        guard validatePassword() else {
            indicateError(error: HSError.passwordDoesntMatch)
            return
        }
        
        userSessionRepository
            .changePassword(userSession: userSession, newPassword: passwordInput.value)
            .done(indicateSuccess(newPassword:)).catch(indicateError(error:))
    }
    
    func signOut() {
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
