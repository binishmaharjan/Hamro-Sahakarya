import Foundation
import Dependencies
import SharedModels

private enum Keys {
    static let userAccount = "userAccount"
}

// MARK: Dependency (liveValue)
extension UserDefaultsClient: DependencyKey {
    public static let liveValue = Self.live(
        userDefaults: .standard,
        jsonDecoder: JSONDecoder(),
        jsonEncoder: JSONEncoder()
    )
}

// MARK: - Live Implementation
extension UserDefaultsClient {
    public static func live(userDefaults: UserDefaults, jsonDecoder: JSONDecoder,jsonEncoder: JSONEncoder) -> Self {
        UserDefaultsClient(
            userAccount: {
                guard let data = userDefaults.data(forKey: Keys.userAccount) else {
                    return .none
                }
                
                guard  let userAccount = try? jsonDecoder.decode(Account.self, from: data) else {
                    fatalError(AppError.UserDefaults.decode.localizedDescription)
                }

                return userAccount
            },
            saveUserAccount: { userAccount in
                guard let data = try? jsonEncoder.encode(userAccount) else {
                    fatalError(AppError.UserDefaults.encode.localizedDescription)
                }
                
                userDefaults.set(data, forKey: Keys.userAccount)
            },
            deleteUserAccount: {
                userDefaults.removeObject(forKey: Keys.userAccount)
            }
        )
    }
}
