//
//  UpdateNoticeViewModel.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2021/10/05.
//  Copyright © 2021 JEC. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol UpdateNoticeStateProtocol {
    var notice: String { get }
}
extension UpdateNoticeStateProtocol {
    var isUpdateNoticeButtonEnabled: Bool {
        return notice.count > 5
    }
}

protocol UpdateNoticeViewModelProtocol {
    var apiState: Driver<State> { get }
    var noticeInput: BehaviorRelay<String?> { get }
    var isUpdateNoticeButtonEnabled: Observable<Bool> { get }
}

struct UpdateNoticeViewModel: UpdateNoticeViewModelProtocol {
    
    
    struct UIState: UpdateNoticeStateProtocol {
        var notice: String
    }
    
    private let userSession: UserSession
    private let userSessionRepository: UserSessionRepository
    
    @PropertyBehaviourRelay<State>(value: .idle)
    var apiState: Driver<State>
    
    var noticeInput = BehaviorRelay<String?>(value: "")
    var isUpdateNoticeButtonEnabled: Observable<Bool>
    
    
    init(userSessionRepository: UserSessionRepository, userSession: UserSession) {
        self.userSessionRepository = userSessionRepository
        self.userSession = userSession
        
        let state = noticeInput.asObservable()
            .map { UIState(notice: $0 ?? "") }
        isUpdateNoticeButtonEnabled = state.map { $0 .isUpdateNoticeButtonEnabled }
    }
}
