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
  
  func logViewModelForRow(at indexPath: IndexPath) -> DefaultLogCellViewModel
  func loadLogs(isFirstLoad: Bool)
}

// TODO: Make this struct
final class DefaultLogViewModel: LogViewModel {
    
  // MARK: Properties
  private let userSessionRepository: UserSessionRepository
  
  private var logs: [GroupLog] = []
  var count: Int { return logs.count }
  var isFirstLoad = true
  
  @PropertyBehaviourRelay(value: State.idle)
  var state: Driver<State>
  
  // MARK: Init
  init(userSessionRepository: UserSessionRepository) {
    self.userSessionRepository = userSessionRepository
  }
  
  // MARK: Methods
  func logViewModelForRow(at indexPath: IndexPath) -> DefaultLogCellViewModel {
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
extension DefaultLogViewModel {
  
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
    
     _state.accept(.completed)
   }
   
   private func indicateLoadFailed(error: Error) {
     _state.accept(.error(error))
   }
}
