import Core
import Foundation
import PromiseKit

public final class UserDefaultsDataStore: UserDataStore {
    private let userProfileCoder: UserProfileCoding
    private let userProfileKey = "UserProfileKey"

    public init(userProfileCoder: UserProfileCoding) {
        self.userProfileCoder = userProfileCoder
    }

    public func readUserProfile() -> Promise<UserSession?> {
        return Promise<UserSession?> { [weak self] seal in

            guard let self = self else {
                seal.fulfill(nil)
                return
            }

            guard let data = UserDefaults.standard.value(forKey: self.userProfileKey) as? Data else {
                seal.fulfill(nil)
                return
            }

            do {
                let userProfile = try userProfileCoder.decode(data: data)
                let userSession = UserSession(profile: userProfile)
                seal.fulfill(userSession)
            } catch {
                seal.reject(error)
            }

        }
    }

    public func save(userProfile: UserProfile?) -> Promise<UserSession> {
        return Promise<UserSession> { seal in

            guard let userProfile = userProfile else {
                seal.reject(HSError.emptyDataError)
                return
            }

            let encodedData = userProfileCoder.encode(userProfile: userProfile)
            UserDefaults.standard.set(encodedData, forKey: userProfileKey)

            let userSession = UserSession(profile: userProfile)
            seal.fulfill(userSession)
        }

    }

    public func delete(userProfile: UserProfile) -> Promise<UserSession> {
        return Promise<UserSession> { seal in
            UserDefaults.standard.removeObject(forKey: userProfileKey)

            let userSession = UserSession(profile: userProfile)
            seal.fulfill(userSession)
        }
    }
}

