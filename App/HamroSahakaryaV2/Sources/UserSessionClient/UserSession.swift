import Foundation
import ComposableArchitecture
import SharedModels
import UserDefaultsClient

public class UserSession {
    private init() { }
    // Singleton Instance
    public static var shared: UserSession = UserSession()
    
    @Dependency(\.userDefaultsClient) private var userDefaultsClient
    
    public func read() -> User? {
        userDefaultsClient.user()
    }
    
    public func save(user: User) {
        userDefaultsClient.saveUser(user)
    }
    
    public func delete() {
        userDefaultsClient.deleteUser()
    }
}

extension UserSession: Equatable {
    public static func == (lhs: UserSession, rhs: UserSession) -> Bool {
        lhs === rhs
    }
}
