import AppUI
import Core
import Foundation
import RxCocoa
import RxSwift

public protocol RemoveMemberUIStateProtocol {
    var selectedMember: UserProfile? { get }
}

extension RemoveMemberUIStateProtocol {
    public var isRemoveMemberButtonEnabled: Bool {
        return selectedMember != nil
    }
}

public protocol RemoveMemberViewModelProtocol {
    var selectedMember: BehaviorRelay<UserProfile?> { get }
    var apiState: Driver<State> { get }
    var removeMemberSuccessful: Driver<Bool> { get }
    var isRemoveMemberButtonEnabled: Observable<Bool> { get }
    
    func fetchAllMembers()
    func removeMember()
    
    func numberOfRows() -> Int
    func viewModelForRow(at indexPath: IndexPath) -> MemberCellViewModel
    func userProfileForRow(at indexPath: IndexPath) -> UserProfile
    func isUserSelected(userProfile: UserProfile) -> Bool
}

public struct RemoveMemberViewModel: RemoveMemberViewModelProtocol {
    public struct UIState: RemoveMemberUIStateProtocol {
        public var selectedMember: UserProfile?
    }
    
    private let userSessionRepository: UserSessionRepository
    private let userSession: UserSession
    private var allMembers: BehaviorRelay<[UserProfile]> = BehaviorRelay(value: [])
    
    public var selectedMember: BehaviorRelay<UserProfile?> = BehaviorRelay(value: nil)
    public var isRemoveMemberButtonEnabled: Observable<Bool>
    
    @PropertyBehaviorRelay<State>(value: .idle)
    public var apiState: Driver<State>
    @PropertyBehaviorRelay<Bool>(value: false)
    public var removeMemberSuccessful: Driver<Bool>
    
    public init(
        userSessionRepository: UserSessionRepository,
        userSession: UserSession
    ) {
        self.userSessionRepository = userSessionRepository
        self.userSession = userSession
        
        let state = selectedMember.asObservable().map { UIState(selectedMember: $0) }
        isRemoveMemberButtonEnabled = state.map { $0.isRemoveMemberButtonEnabled }
    }
    
    public func numberOfRows() -> Int {
        return allMembers.value.count
    }
    
    public func viewModelForRow(at indexPath: IndexPath) -> MemberCellViewModel {
        return DefaultMemberCellViewModel(profile: userProfileForRow(at: indexPath))
    }
    
    public func userProfileForRow(at indexPath: IndexPath) -> UserProfile {
        return allMembers.value[indexPath.row]
    }
    
    public func isUserSelected(userProfile: UserProfile) -> Bool {
        return userProfile == selectedMember.value
    }
}

// MARK: Api
extension RemoveMemberViewModel {
    public func fetchAllMembers() {
        indicateLoading()
        
        userSessionRepository
            .getAllMembers()
            .done(indicateGetMemberSuccessful)
            .catch(indicateError(error:))
    }
    
    public func removeMember() {
        indicateLoading()
        
        guard let selectedMember = self.selectedMember.value else {
            indicateError(error: HSError.unknown)
            return
        }
        
        userSessionRepository
            .removeMember(admin: userSession.profile.value, member: selectedMember)
            .done(indicateGetRemoveMemberSuccessful)
            .catch(indicateError(error:))
    }
    
    private func indicateLoading() {
        _removeMemberSuccessful.accept(false)
        _apiState.accept(.loading)
    }
    
    private func indicateGetMemberSuccessful(members: [UserProfile]) {
        let allMembersExcludingSelf = members.filter { !($0.email == userSession.profile.value.email) }
        allMembers.accept(allMembersExcludingSelf)
        _apiState.accept(.completed)
    }
    
    private func indicateGetRemoveMemberSuccessful() {
        _removeMemberSuccessful.accept(true)
        selectedMember.accept(nil)
        _apiState.accept(.completed)
    }
    
    private func indicateError(error: Error) {
        _apiState.accept(.error(error))
    }
}
