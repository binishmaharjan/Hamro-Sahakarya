import Foundation
import Core

// MARK: Temporary
public protocol SignedInResponder {
    func signedIn(to userSession: UserSession)
}

public protocol GoToSignUpNavigator {
    func navigateToSignUp()
}
