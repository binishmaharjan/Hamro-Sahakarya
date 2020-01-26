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

protocol LogViewModelProtocol {
  var logs: [GroupLog] { get }
  var count: Int { get }
  
  func logViewModelForRow(at indexPath: IndexPath) -> LogCellViewModel
  func loadLogs(isFirstLoad: Bool)
}

final class LogViewModel: LogViewModelProtocol {
  
  enum State {
    case idle
    case completed
    case error
    case loading
  }
  
  // MARK: Properties
  private let userSessionRepository: UserSessionRepository
  
  internal var logs: [GroupLog] = []
  var count: Int { return logs.count }
  var isFirstLoad = true
  
  @PropertyBehaviourRelay(value: State.idle)
  var state: Driver<State>
  
  // MARK: Init
  init(userSessionRepository: UserSessionRepository) {
    self.userSessionRepository = userSessionRepository
  }
  
  // MARK: Methods
  func logViewModelForRow(at indexPath: IndexPath) -> LogCellViewModel {
    return .init(groupLog: logs[indexPath.row])
  }
  
  func loadLogs(isFirstLoad: Bool = false) {
    indicateLoading()
    
    userSessionRepository.getLogs()
      .done(indicateLoadSuccessful)
      .catch(indicateLoadFailed)
      
  }
}

// MARK: Indication
extension LogViewModel {
  
   private func indicateLoading() {
     _state.accept(.loading)
   }
   
   private func indicateLoadSuccessful(logs: [GroupLog]) {
     
     switch isFirstLoad{
     case true:
       isFirstLoad = false
       self.logs = logs
      
     case false:
       break
     }
    print(logs)
     _state.accept(.completed)
   }
   
   private func indicateLoadFailed(error: Error) {
     _state.accept(.error)
   }
}
