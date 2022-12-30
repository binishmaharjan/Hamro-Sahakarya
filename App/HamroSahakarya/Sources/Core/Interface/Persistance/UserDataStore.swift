import Foundation
import PromiseKit

public protocol UserDataStore {
    func readUserProfile() -> Promise<UserSession?>
    func save(userProfile: UserProfile?) -> Promise<UserSession>
    func delete(userProfile: UserProfile) -> Promise<UserSession>
}
