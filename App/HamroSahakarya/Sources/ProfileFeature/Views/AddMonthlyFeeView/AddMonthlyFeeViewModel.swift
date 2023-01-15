import AppUI
import Core
import Foundation
import RxCocoa
import RxSwift
import UIKit

public protocol AddMonthlyFeeStateProtocol {
    var monthlyFeeAmount: Int { get }
}

extension AddMonthlyFeeStateProtocol {
    public var isAddButtonEnabled: Bool {
        return monthlyFeeAmount > 0
    }
}

public protocol AddMonthlyFeeViewModel {
    var numberOfSection: Int { get }
    var apiState: Driver<State> { get }
    var addMonthlyFeeSuccessful: Driver<Bool> { get }
    var monthAmountInput: BehaviorRelay<Int> { get }
    var isAddButtonEnabled: Observable<Bool> { get }
    
    func numberOfRows(for section: Int) -> Int
    func addMonthlyFee()
    func getRow(at indexPath: IndexPath) -> AddMonthlyFeeRow
    func getAccessoryTypeForRow(at indexPath: IndexPath) -> UITableViewCell.AccessoryType
    func getHeaderTitle(for section: Int) -> String
    func getAllMembers()
    func deselectAllMember()
    func toggleSelected(member: UserProfile)
}

public enum AddMonthlyFeeRow {
    case all
    case member(UserProfile, MemberCellViewModel)
}

//public enum AddMonthlyFeeLastApiCompletion {
//    case getMembers
//    case addMonthlyFee
//}

public final class DefaultAddMonthlyFeeViewModel: AddMonthlyFeeViewModel {
    struct UIState: AddMonthlyFeeStateProtocol {
        var monthlyFeeAmount: Int
    }
    
    struct Section {
        let rows: [AddMonthlyFeeRow]
    }
    
    private var userSessionRepository: UserSessionRepository
    private var userSession: UserSession
    
    private let dispatchGroup: DispatchGroup = DispatchGroup()
    private var addMonthlyFeeErrorHasError: Bool = false
    
    public var isAddButtonEnabled: Observable<Bool>
    
    private var allMembers: [UserProfile] = []
    private var selectedMember: [UserProfile] = []
    private var tableViewSection: [Section]  {
        let section = [
            Section(rows: [AddMonthlyFeeRow.all]),
            Section(rows: allMembers.map { AddMonthlyFeeRow.member($0, DefaultMemberCellViewModel(profile: $0)) })
        ]
        
        return section
    }
    
    @PropertyBehaviorRelay<State>(value: .idle)
    public var apiState: Driver<State>
    @PropertyBehaviorRelay<Bool>(value: false)
    public var addMonthlyFeeSuccessful: Driver<Bool>
    public let monthAmountInput = BehaviorRelay<Int>(value: 0)
    
    public var numberOfSection: Int {
        return tableViewSection.count
    }
    
    public init(
        userSessionRepository: UserSessionRepository,
        userSession: UserSession
    ) {
        self.userSessionRepository = userSessionRepository
        self.userSession = userSession
        
        let state = monthAmountInput.asObservable().map { UIState(monthlyFeeAmount: $0) }
        isAddButtonEnabled = state.map { $0.isAddButtonEnabled }
    }
    
    // MARK: Binding Values
    public func getRow(at indexPath: IndexPath) -> AddMonthlyFeeRow {
        return tableViewSection[indexPath.section].rows[indexPath.row]
    }
    
    public func numberOfRows(for section: Int) -> Int {
        return tableViewSection[section].rows.count
    }
    
    public func getHeaderTitle(for section: Int) -> String {
        return section == 0 ? "All" : "Members"
    }
    
    public func getAccessoryTypeForRow(at indexPath: IndexPath) -> UITableViewCell.AccessoryType {
        let row = getRow(at: indexPath)
        switch row {
        case .all:
            return selectedMember.isEmpty ? .checkmark : .none
        case .member(let userProfile, _):
            return isSelected(member: userProfile) ? .checkmark : .none
        }
    }
    
    // MARK: Selection
    public func isSelected(member: UserProfile) -> Bool {
        return selectedMember.contains(member)
    }
    
    public func toggleSelected(member: UserProfile) {
        if let index = selectedMember.firstIndex(of: member) {
            selectedMember.remove(at: index)
        } else {
            selectedMember.append(member)
        }
    }
    
    public func deselectAllMember() {
        selectedMember.removeAll()
    }
}

// MARK: Apis
extension DefaultAddMonthlyFeeViewModel {
    public func getAllMembers() {
        indicateLoading()
        userSessionRepository.getAllMembers()
            .done(indicateGetMemberSuccess(members:))
            .catch(indicateError(error:))
    }
    
    public func addMonthlyFee() {
        indicateLoading()
        
        let targetUser: [UserProfile] = selectedMember.isEmpty ? allMembers : selectedMember
        
        targetUser.forEach { (userProfile) in
            dispatchGroup.enter()
            
            userSessionRepository.addMonthlyFeeLog(admin: userSession.profile.value, user: userProfile, amount: monthAmountInput.value)
                .done { [weak self] in self?.indicateAddMonthlyFeeSuccess() }
                .catch(indicateError(error: ))
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let this = self else { return }
            
            if this.addMonthlyFeeErrorHasError {
                this.addMonthlyFeeErrorHasError = false
                this._apiState.accept(.error(HSError.unknown))
            } else {
                this._apiState.accept(.completed)
            }
            
        }
    }
    
    private func indicateLoading() {
        _addMonthlyFeeSuccessful.accept(false)
        _apiState.accept(.loading)
    }
    
    private func indicateAddMonthlyFeeSuccess() {
        _addMonthlyFeeSuccessful.accept(true)
        dispatchGroup.leave()
    }
    
    private func indicateGetMemberSuccess(members: [UserProfile]) {
        allMembers = members
        _apiState.accept(.completed)
    }
    
    private func indicateAddMonthlyFeeError(error: Error) {
        addMonthlyFeeErrorHasError = true
        dispatchGroup.leave()
    }
    
    private func indicateError(error: Error) {
        _apiState.accept(.error(error))
    }
}

