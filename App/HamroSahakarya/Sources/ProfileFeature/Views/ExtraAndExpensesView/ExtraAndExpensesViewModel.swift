import AppUI
import Core
import Foundation
import RxCocoa
import RxSwift

public protocol ExtraAndExpensesStateProtocol {
    var amount: Int { get }
    var reason: String { get }
}

extension ExtraAndExpensesStateProtocol {
    public var isConfirmButtonEnabled: Bool {
        return amount > 0 && reason.isNotEmpty()
    }
}

public protocol ExtraAndExpensesViewModelProtocol {
    var selectedTypeInput: BehaviorRelay<ExtraOrExpenses> { get }
    var amountInput: BehaviorRelay<Int> { get }
    var reasonInput: BehaviorRelay<String> { get }
    var isConfirmButtonEnabled: Observable<Bool> { get }
    
    var apiState: Driver<State> { get }
    
    func updateExtraOrExpenses()
}

public struct ExtraAndExpensesViewModel: ExtraAndExpensesViewModelProtocol {
    public struct UIState: ExtraAndExpensesStateProtocol {
        public var amount: Int
        public var reason: String
    }
    
    private var userSessionRepository: UserSessionRepository
    private var userSession: UserSession
    
    public var selectedTypeInput: BehaviorRelay<ExtraOrExpenses> = BehaviorRelay(value: .extra)
    public var amountInput: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var reasonInput: BehaviorRelay<String> = BehaviorRelay(value: "")
    public var isConfirmButtonEnabled: Observable<Bool>
    
    @PropertyBehaviorRelay<State>(value: .idle)
    public var apiState: Driver<State>
    
    public init(
        userSessionRepository: UserSessionRepository,
        userSession: UserSession
    ) {
        self.userSessionRepository = userSessionRepository
        self.userSession = userSession
        
        let state = Observable.combineLatest(amountInput,reasonInput).map { UIState(amount: $0, reason: $1) }
        isConfirmButtonEnabled = state.map { $0.isConfirmButtonEnabled }
    }

    public func updateExtraOrExpenses() {
        indicateLoading()
        
        userSessionRepository
            .updateExtraAndExpenses(admin: userSession.profile.value, type: selectedTypeInput.value, amount: amountInput.value, reason: reasonInput.value)
            .done{ self.indicateSuccess() }
            .catch(indicateError(error:))
    }
}

// MARK: Indication
extension ExtraAndExpensesViewModel {
    private func indicateLoading() {
        _apiState.accept(.loading)
    }
    
    private func indicateSuccess() {
        _apiState.accept(.completed)
    }
    
    private func indicateError(error: Error) {
        _apiState.accept(.error(error))
    }
}
