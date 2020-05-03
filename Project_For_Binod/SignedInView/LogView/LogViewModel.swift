//
//  LogViewModel.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/01/19.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol LogViewModel {
    var count: Int { get }
    var state: Driver<State> { get }
    var lastCount: Int { get }
    var isRefreshing: Driver<Bool> { get }
    
    func logViewModelForRow(at indexPath: IndexPath) -> DefaultLogCellViewModel
    func fetchLogs(isRefresh: Bool)
    func fetchMoreLogs()
}

// TODO: Make this struct
final class DefaultLogViewModel: LogViewModel {
    
    // MARK: Properties
    private let userSessionRepository: UserSessionRepository
    private var isLastPage: Bool = false
    private var logs: [GroupLog] = []
    
    var count: Int { return logs.count }
    let lastCount: Int = 0
    
    @PropertyBehaviourRelay(value: State.idle)
    var state: Driver<State>
    
    @PropertyBehaviourRelay(value: false)
    var isRefreshing: Driver<Bool>
    
    // MARK: Init
    init(userSessionRepository: UserSessionRepository) {
        self.userSessionRepository = userSessionRepository
    }
    
    // MARK: Methods
    func logViewModelForRow(at indexPath: IndexPath) -> DefaultLogCellViewModel {
        return .init(groupLog: logs[indexPath.row])
    }
    
    func fetchLogs(isRefresh: Bool = false) {
        if isRefresh { _isRefreshing.accept(true) }
        indicateLoading()
        
        userSessionRepository.getLogs()
            .done(indicateLoadSuccessful)
            .catch(indicateLoadFailed)
        
    }
    
    func fetchMoreLogs() {
        guard !isLastPage else {
            Dlog("There are no more logs.")
            return
        }
        
        if case .loading = _state.value {
            Dlog("Logs are loading.")
            return
        }
        
        indicateLoading()
        
        userSessionRepository
            .fetchMoreLogsFromLastSnapShot()
            .done(indicateFetchMoreLogSuccesful)
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
    
    func indicateFetchMoreLogSuccesful(logs: [GroupLog]) {
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
