import AppUI
import Core
import Foundation
import RxSwift
import RxCocoa

public protocol LoanReturnedUIStateProtocol {
    var selectedMember: UserProfile? { get }
    var returnedAmount: Int { get }
}

extension LoanReturnedUIStateProtocol {
    public var isReturnAmountButtonEnabled: Bool {
        return selectedMember != nil && returnedAmount > 0
    }
}

public protocol LoanReturnedViewModelProtocol {
    var returnedAmount: BehaviorRelay<Int> { get }
    var selectedMember: BehaviorRelay<UserProfile?> { get }
    var isReturnAmountButtonEnabled: Observable<Bool> { get }

    var apiState: Driver<State> { get }
    var returnedAmountSuccessful: Driver<Bool> { get }

    func getAllMembersWithLoan()
    func returnAmount()

    func numberOfRows() -> Int
    func viewModelForRow(at indexPath: IndexPath) -> MemberWithLoanViewModelProtocol
    func userProfileForRow(at indexPath: IndexPath) -> UserProfile
    func isUserSelected(userProfile: UserProfile) -> Bool
}

public struct LoanReturnedViewModel: LoanReturnedViewModelProtocol {
    public struct UIState: LoanReturnedUIStateProtocol {
        public  var selectedMember: UserProfile?
        public var returnedAmount: Int
    }
    
    private let userSessionRepository: UserSessionRepository
    private let userSession: UserSession
    private let allMembers: BehaviorRelay<[UserProfile]> = BehaviorRelay(value: [])
    
    public var returnedAmount: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var selectedMember: BehaviorRelay<UserProfile?> = BehaviorRelay(value: nil)
    public var isReturnAmountButtonEnabled: Observable<Bool>
    
    @PropertyBehaviorRelay<State>(value: .idle)
    public var apiState: Driver<State>
    @PropertyBehaviorRelay<Bool>(value: false)
    public var returnedAmountSuccessful: Driver<Bool>
    
    public init(
        userSessionRepository: UserSessionRepository,
        userSession: UserSession
    ) {
        self.userSessionRepository = userSessionRepository
        self.userSession = userSession
        
        let state = Observable.combineLatest(selectedMember, returnedAmount)
            .map { UIState(selectedMember: $0, returnedAmount: $1) }
        self.isReturnAmountButtonEnabled = state.map { $0.isReturnAmountButtonEnabled }
    }

    public func numberOfRows() -> Int {
        allMembers.value.count
    }
    
    public func viewModelForRow(at indexPath: IndexPath) -> MemberWithLoanViewModelProtocol {
        return MemberWithLoanCellViewModel(profile: userProfileForRow(at: indexPath))
    }
    
    public func userProfileForRow(at indexPath: IndexPath) -> UserProfile {
        return allMembers.value[indexPath.row]
    }
    
    public func isUserSelected(userProfile: UserProfile) -> Bool {
        guard let selectedMember = selectedMember.value else { return false }
        
        return userProfile == selectedMember
    }
}

extension LoanReturnedViewModel {
    public func returnAmount() {
        indicateLoading()
        
        guard let selectedMember = selectedMember.value else {
            _apiState.accept(.error(HSError.unknown))
            return
        }
        
        userSessionRepository
            .loanReturned(admin: userSession.profile.value, member: selectedMember, amount: returnedAmount.value)
            .done{ self.indicateReturnedAmountSuccessful() }
            .catch(indicateError(error:))
    }
    
    public func getAllMembersWithLoan() {
        indicateLoading()
        
        userSessionRepository
            .getAllMembersWithLoan()
            .done(indicateGetLoanMemberSuccessful)
            .catch(indicateError(error:))
    }
    
    private func indicateLoading() {
        _returnedAmountSuccessful.accept(false)
        _apiState.accept(.loading)
    }
    
    private func indicateGetLoanMemberSuccessful(members: [UserProfile]) {
        allMembers.accept(members)
        _apiState.accept(.completed)
    }
    
    private func indicateReturnedAmountSuccessful() {
        _returnedAmountSuccessful.accept(true)
        selectedMember.accept(nil)
        _apiState.accept(.completed)
    }
    
    private func indicateError(error: Error) {
        _apiState.accept(.error(error))
    }
}
