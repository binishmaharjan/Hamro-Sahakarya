import Foundation

public protocol SignInViewModelFactory {
    func makeSignInViewModel() -> SignInViewModel
}
