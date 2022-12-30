import Foundation

public protocol UserProfileCoding {

    func encode(userProfile: UserProfile) -> Data
    func decode(data: Data) throws -> UserProfile
}
