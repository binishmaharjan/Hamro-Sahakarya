import Core
import Foundation
import RxCocoa

public protocol ProfileTopCellViewModel {
    var imageUrl: Driver<URL?> { get }
    var fullName: Driver<String> { get }
    var status: Driver<String> { get }
}

public struct DefaultProfileTopCellViewModel: ProfileTopCellViewModel {
    private let userSession: UserSession
    
    public var imageUrl: Driver<URL?> {
        return userSession.profile
            .map { $0.iconUrl }
            .map { URL(string: $0 ?? "") }
            .asDriver()
    }
    
    public var fullName: Driver<String> {
        return userSession.profile
            .map { $0.username }
            .asDriver()
    }
    
    public var status: Driver<String> {
        return userSession.profile
            .map { $0.status.rawValue }
            .asDriver()
    }
    
    public init(userSession: UserSession) {
        self.userSession = userSession
    }
}
