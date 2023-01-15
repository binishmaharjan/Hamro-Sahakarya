import AppUI
import Core
import Foundation
import RxCocoa
import RxSwift

public protocol AddOrDeductStateProtocol {
    var selectedUser: UserProfile? { get }
    var amount: Int { get }
}

extension AddOrDeductStateProtocol {
    public var isConfirmButtonEnabled: Bool {
        return selectedUser != nil && amount > 0
    }
}

public protocol AddOrDeductAmountViewModelProtocol {
    var selectedTypeInput: BehaviorRelay<AddOrDeduct> { get }
    var selectedUser: BehaviorRelay<UserProfile?> { get }
    var amountInput: BehaviorRelay<Int> { get }
    
    var isConfirmButtonEnabled: Observable<Bool> { get }
    var apiState: Driver<State> { get }
    var addOrDeductSuccessful: Driver<Bool> { get }
    
    func addOrDeduct()
    func fetchAllMembers()
    func numberOfRows() -> Int
    func viewModelForRow(at indexPath: IndexPath) -> MemberCellViewModel
    func userProfileForRow(at indexPath: IndexPath) -> UserProfile
    func isUserSelected(userProfile: UserProfile) -> Bool
}

public struct AddOrDeductAmountViewModel: AddOrDeductAmountViewModelProtocol {
    public struct UIState: AddOrDeductStateProtocol {
        public var selectedUser: UserProfile?
        public var amount: Int
    }
    
    private var allMembers: BehaviorRelay<[UserProfile]> = BehaviorRelay(value: [])
    private let userSessionRepository: UserSessionRepository
    private let userSession: UserSession
    
    public var selectedTypeInput: BehaviorRelay<AddOrDeduct> = BehaviorRelay(value: .add)
    public var selectedUser: BehaviorRelay<UserProfile?> = BehaviorRelay(value: nil)
    public var amountInput: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var isConfirmButtonEnabled: Observable<Bool>
    
    @PropertyBehaviorRelay<State>(value: .idle)
    public var apiState: Driver<State>
    @PropertyBehaviorRelay<Bool>(value: false)
    public var addOrDeductSuccessful: Driver<Bool>
    
    public init(
        userSessionRepository: UserSessionRepository,
        userSession: UserSession
    ) {
        self.userSessionRepository = userSessionRepository
        self.userSession = userSession
        
        let state = Observable.combineLatest(selectedUser, amountInput) { UIState(selectedUser: $0, amount: $1) }
        isConfirmButtonEnabled = state.map { $0.isConfirmButtonEnabled }
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
        guard let selectedMember = selectedUser.value else { return false }
        
        return userProfile == selectedMember
    }
}

// MARK: Api
extension AddOrDeductAmountViewModel {
    public func addOrDeduct() {
        indicateLoading()
        
        guard let selectedUser = selectedUser.value else {
            _apiState.accept(.error(HSError.unknown))
            return
        }
        
        userSessionRepository
            .addOrDeductAmount(admin: userSession.profile.value, member: selectedUser, type: selectedTypeInput.value, amount: amountInput.value)
            .done{ self.indicateAddOrDeductSuccessful() }
            .catch(indicateError(error:))
    }
    
    public func fetchAllMembers() {
        indicateLoading()
        
        userSessionRepository
            .getAllMembers()
            .done(indicateFetchAllMemberSuccessful(members:))
            .catch(indicateError(error:))
    }
    
    private func indicateLoading() {
        _addOrDeductSuccessful.accept(false)
        _apiState.accept(.loading)
    }
    
    private func indicateAddOrDeductSuccessful() {
        _addOrDeductSuccessful.accept(true)
        selectedUser.accept(nil)
        _apiState.accept(.completed)
    }
    
    private func indicateFetchAllMemberSuccessful(members: [UserProfile]) {
        allMembers.accept(members)
        _apiState.accept(.completed)
    }
    
    private func indicateError(error: Error) {
        _apiState.accept(.error(error))
    }
}
