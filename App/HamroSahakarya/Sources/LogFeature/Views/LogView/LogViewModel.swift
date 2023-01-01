import AppUI
import Core
import Foundation
import RxCocoa
import RxSwift

public protocol LogViewModel {
    var count: Int { get }
    var state: Driver<State> { get }
    var lastCount: Int { get }
    var isRefreshing: Driver<Bool> { get }
    
    func logViewModelForRow(at indexPath: IndexPath) -> DefaultLogCellViewModel
    func fetchLogs(isRefresh: Bool)
    func fetchMoreLogs()
}

// TODO: Make this struct
public final class DefaultLogViewModel: LogViewModel {
    // MARK: Properties
    private let userSessionRepository: UserSessionRepository
    private var isLastPage: Bool = false
    private var logs: [GroupLog] = []
    
    public var count: Int { return logs.count }
    public let lastCount: Int = 0
    
    @PropertyBehaviorRelay(value: State.idle)
    public var state: Driver<State>
    
    @PropertyBehaviorRelay(value: false)
    public var isRefreshing: Driver<Bool>
    
    // MARK: Init
    public init(userSessionRepository: UserSessionRepository) {
        self.userSessionRepository = userSessionRepository
    }
    
    // MARK: Methods
    public func logViewModelForRow(at indexPath: IndexPath) -> DefaultLogCellViewModel {
        return .init(groupLog: logs[indexPath.row])
    }
    
    public func fetchLogs(isRefresh: Bool = false) {
        if isRefresh { _isRefreshing.accept(true) }
        indicateLoading()
        
        userSessionRepository.getLogs()
            .done(indicateLoadSuccessful)
            .catch(indicateLoadFailed)
    }
    
    public func fetchMoreLogs() {
        guard !isLastPage else {
            DebugLog("There are no more logs.")
            return
        }
        
        if case .loading = _state.value {
            DebugLog("Logs are loading.")
            return
        }
        
        indicateLoading()
        
        userSessionRepository
            .fetchMoreLogsFromLastSnapShot()
            .done(indicateFetchMoreLogSuccessful)
            .catch(indicateLoadFailed)
    }
}

// MARK: Indication
extension DefaultLogViewModel {
    
    private func indicateLoading() {
        _state.accept(.loading)
    }
    
    private func indicateLoadSuccessful(logs: [GroupLog]) {
        isLastPage = false
        
        self.logs = logs

        _state.accept(.completed)
        _isRefreshing.accept(false)
    }
    
    private func indicateFetchMoreLogSuccessful(logs: [GroupLog]) {
        if logs.count == 0 {
            isLastPage = true
        }
        
        self.logs.append(contentsOf: logs)
        
        _state.accept(.completed)
    }
    
    private func indicateLoadFailed(error: Error) {
        _state.accept(.error(error))
        _isRefreshing.accept(false)
    }
}
