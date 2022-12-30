import Foundation
import PromiseKit

public protocol AuthRemoteApi {
    func signIn(email: String, password: String) -> Promise<String>
    func signUp(newAccount: NewAccount) -> Promise<String>
    func signOut(userSession: UserSession) -> Promise<UserSession>
    func changePassword(newPassword: String) -> Promise<String>
}
