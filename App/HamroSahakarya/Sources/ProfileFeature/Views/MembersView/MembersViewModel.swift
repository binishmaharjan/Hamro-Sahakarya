import AppUI
import Core
import Foundation
import RxCocoa
import RxSwift

public protocol MembersViewModel {
    var count: Int { get }
    var apiState: Driver<State> { get }
    
    func viewModelForRow(at indexPath: IndexPath) -> MemberCellViewModel
    func getAllMembers()
}

public final class DefaultMembersViewModel: MembersViewModel {
    // MARK: Properties
    private var profiles: [UserProfile] = []
    private let userSessionRepository: UserSessionRepository
    @PropertyBehaviorRelay<State>(value: .idle)
    public var apiState: Driver<State>
    
    public var count: Int {
        return profiles.count
    }
    
    public init(userSessionRepository: UserSessionRepository) {
        self.userSessionRepository = userSessionRepository
    }
    
    // MARK: Methods
    public func viewModelForRow(at indexPath: IndexPath) -> MemberCellViewModel {
        return DefaultMemberCellViewModel(profile: profiles[indexPath.row])
    }
    
    public func getAllMembers() {
        indicateLoading()
        userSessionRepository.getAllMembers()
            .done(indicateLoadSuccessful(profiles:))
            .catch(indicateError(error:))
    }
}

// MARK: Indication
extension DefaultMembersViewModel {
    private func indicateLoading() {
        _apiState.accept(.loading)
    }
    
    private func indicateLoadSuccessful(profiles: [UserProfile]) {
        self.profiles = profiles
        _apiState.accept(.completed)
    }
    
    private func indicateError(error: Error) {
        _apiState.accept(.error(error))
    }
}
