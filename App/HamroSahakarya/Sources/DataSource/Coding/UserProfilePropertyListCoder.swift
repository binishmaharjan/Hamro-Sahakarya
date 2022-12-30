import Core
import Foundation

public final class UserProfilePropertyListCoder: UserProfileCoding {
    public init() {}

    public func encode(userProfile: UserProfile) -> Data {
        return try! PropertyListEncoder().encode(userProfile)
    }

    public func decode(data: Data) throws -> UserProfile {
        do {
            return try PropertyListDecoder().decode(UserProfile.self, from: data)
        } catch {
            throw HSError.dataDecodingError
        }
    }
}
