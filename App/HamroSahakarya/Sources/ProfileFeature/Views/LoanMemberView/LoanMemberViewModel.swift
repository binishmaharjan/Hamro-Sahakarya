import AppUI
import Core
import Foundation
import RxCocoa
import RxSwift

public protocol LoanMemberStateProtocol {
    var selectedMember: UserProfile? { get }
    var loanAmount: Int { get }
}

extension LoanMemberStateProtocol {
    public var isLoanMemberButtonEnabled: Bool {
        guard selectedMember.exists else { return false }
        return loanAmount > 0
    }
}

public protocol LoanMemberViewModelProtocol {
    var loanAmount: BehaviorRelay<Int> { get }
    var selectedMember: BehaviorRelay<UserProfile?> { get }
    var isLoanMemberButtonEnabled: Observable<Bool> { get }
    
    var apiState: Driver<State> { get }
    var loanMemberSuccessful: Driver<Bool> { get }
    
    func getAllMembers()
    func loanMember()
    
    func numberOfRows() -> Int
    func viewModelForRow(at indexPath: IndexPath) -> MemberCellViewModel
    func userProfileForRow(at indexPath: IndexPath) -> UserProfile
    func isUserSelected(userProfile: UserProfile) -> Bool
}

public struct LoanMemberViewModel: LoanMemberViewModelProtocol {
    public struct UIState: LoanMemberStateProtocol {
        public var selectedMember: UserProfile?
        public var loanAmount: Int
    }
    
    private var allMembers: BehaviorRelay<[UserProfile]> = BehaviorRelay(value: [])
    private var userSessionRepository: UserSessionRepository
    private var userSession: UserSession
    
    public var loanAmount: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var selectedMember: BehaviorRelay<UserProfile?> = BehaviorRelay(value: nil)
    public var isLoanMemberButtonEnabled: Observable<Bool>
    
    @PropertyBehaviorRelay<State>(value: .idle)
    public var apiState: Driver<State>
    @PropertyBehaviorRelay<Bool>(value: false)
    public var loanMemberSuccessful: Driver<Bool>
    
    public init(
        userSessionRepository: UserSessionRepository,
        userSession: UserSession
    ) {
        self.userSessionRepository = userSessionRepository
        self.userSession = userSession
        
        let state = Observable.combineLatest(selectedMember,loanAmount).map { UIState(selectedMember: $0, loanAmount: $1) }
        isLoanMemberButtonEnabled = state.map { $0.isLoanMemberButtonEnabled }
    }
    
    public func numberOfRows() -> Int {
        return allMembers.value.count
    }
    
    public func viewModelForRow(at indexPath: IndexPath) -> MemberCellViewModel {
        let member = userProfileForRow(at: indexPath)
        return DefaultMemberCellViewModel(profile: member)
    }
    
    public func userProfileForRow(at indexPath: IndexPath) -> UserProfile {
        return allMembers.value[indexPath.row]
    }
    
    public func isUserSelected(userProfile: UserProfile) -> Bool {
        guard let selectedMember = selectedMember.value else { return false }
        
        return userProfile == selectedMember
    }
}

// MARK: Api
extension LoanMemberViewModel {
    public func getAllMembers() {
        indicateLoading()
        
        userSessionRepository
            .getAllMembers()
            .done(indicateGetMemberSuccessful(members:))
            .catch(indicateError(error:))
    }
    
    public func loanMember() {
        indicateLoading()
        
        guard let selectedMember = selectedMember.value else {
            indicateError(error: HSError.unknown)
            return
        }
        
        userSessionRepository
            .loanMember(admin: userSession.profile.value, member: selectedMember, amount: loanAmount.value)
            .done { self.indicateLoanMemberSuccessful() }
            .catch(indicateError(error:))
    }
    
    private func indicateLoading() {
        _loanMemberSuccessful.accept(false)
        _apiState.accept(.loading)
    }
    
    private func indicateGetMemberSuccessful(members: [UserProfile]) {
        allMembers.accept(members)
        _apiState.accept(.completed)
    }
    
    private func indicateLoanMemberSuccessful() {
        _loanMemberSuccessful.accept(true)
        selectedMember.accept(nil)
        _apiState.accept(.completed)
    }
    
    private func indicateError(error: Error) {
        _apiState.accept(.error(error))
    }
}
