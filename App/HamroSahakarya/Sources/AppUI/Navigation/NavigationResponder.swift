import Core
import Foundation

/// Change the MainView to SignedInView
public protocol SignedInResponder {
    func signedIn(to userSession: UserSession)
}

/// Change the MainView to OnboardingView
public protocol NotSignedInResponder {
    func notSignedIn()
}
