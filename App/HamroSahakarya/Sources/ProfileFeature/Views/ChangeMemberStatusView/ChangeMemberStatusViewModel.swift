import AppUI
import Core
import Foundation
import RxCocoa
import RxSwift

public protocol ChangeMemberStatusViewModel {
    var numberOfSection: Int { get }
    var apiState: Driver<State> { get }
    
    func numberOfRows(for section: Int) -> Int
    func viewModelForRow(at indexPath: IndexPath) -> MemberCellViewModel
    func isUpgradeForMember(at indexPath: IndexPath) -> Bool
    func getStatus(for section: Int) -> Status
    func changeStatusForMember(at indexPath: IndexPath)
    func getAllMembers()
}

public final class DefaultChangeMemberStatusViewModel: ChangeMemberStatusViewModel {
    private struct Section {
        let row: [UserProfile]
        let status: Status
    }
    
    private var userSessionRepository: UserSessionRepository
    private var userSession: UserSession
    private var allMembers: [UserProfile] = []
    private var tableViewSection: [Section] {
        let section = [
            Section(row: allMembers.filter{ $0.status == .admin}, status: .admin),
            Section(row: allMembers.filter{ $0.status == .member}, status: .member ),
        ]
        
        return section
    }
    
    @PropertyBehaviorRelay<State>(value: .idle)
    public var apiState: Driver<State>
    public var numberOfSection: Int {
        return tableViewSection.count
    }
    
    public init(
        userSessionRepository: UserSessionRepository,
        userSession: UserSession
    ) {
        self.userSessionRepository = userSessionRepository
        self.userSession = userSession
    }
    
    public func numberOfRows(for section: Int) -> Int {
        return tableViewSection[section].row.count
    }
    
    public func viewModelForRow(at indexPath: IndexPath) -> MemberCellViewModel {
        let userProfile = userProfileForRow(at: indexPath)
        return DefaultMemberCellViewModel(profile: userProfile)
    }
    
    public func getStatus(for section: Int) -> Status {
        tableViewSection[section].status
    }
    
    public func isUpgradeForMember(at indexPath: IndexPath) -> Bool {
        let userProfile = userProfileForRow(at: indexPath)
        return userProfile.status == .admin ? false : true
    }
    
    public func getAllMembers() {
        indicateLoading()
        userSessionRepository.getAllMembers()
            .done(indicateGetMemberSuccess(members:))
            .catch(indicateError(error:))
    }
    
    public func changeStatusForMember(at indexPath: IndexPath) {
        guard canChangeStatusForMember(at: indexPath) else {
            _apiState.accept(.error(HSError.cannotChangeOwnStatus))
            return
        }
        
        indicateLoading()
        let userProfile = tableViewSection[indexPath.section].row[indexPath.row]
        
        userSessionRepository
            .changeStatus(for: userProfile)
            .done{ [weak self] in self?.indicateChangeStatusSuccess() }
            .catch(indicateError(error:))
    }
    
    private func canChangeStatusForMember(at indexPath: IndexPath) -> Bool {
        let myUid = userSession.profile.value.uid
        let selectedUserUid = userProfileForRow(at: indexPath).uid
        
        return myUid != selectedUserUid
    }
    
    private func userProfileForRow(at indexPath: IndexPath) -> UserProfile {
        return tableViewSection[indexPath.section].row[indexPath.row]
    }
}

extension DefaultChangeMemberStatusViewModel {
    private func indicateLoading() {
        _apiState.accept(.loading)
    }
    
    private func indicateGetMemberSuccess(members: [UserProfile]) {
        allMembers = members
        _apiState.accept(.completed)
    }
    
    private func indicateChangeStatusSuccess() {
        getAllMembers()
    }
    
    private func indicateError(error: Error) {
        _apiState.accept(.error(error))
    }
}
