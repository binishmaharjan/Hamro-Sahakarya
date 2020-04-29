//
//  RemoveMemberViewModel.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/04/29.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol RemoveMemberViewModelProtocol {
    var selectedMember: BehaviorRelay<UserProfile?> { get }
    var apiState: Driver<State> { get }
    
    func getAllMembers()
    func removeMember()
    
    func numberOfRows() -> Int
    func viewModelForRow(at indexPath: IndexPath) -> MemberCellViewModel
    func userProfileForRow(at indexPath: IndexPath) -> UserProfile
    func isUserSelected(userProfile: UserProfile) -> Bool
}

struct RemoveMemberViewModel: RemoveMemberViewModelProtocol {
    
    private let userSessionRepository: UserSessionRepository
    private let userSession: UserSession
    
    var selectedMember: BehaviorRelay<UserProfile?> = BehaviorRelay(value: nil)
    
     @PropertyBehaviourRelay<State>(value: .idle)
    var apiState: Driver<State>
    
    init(userSessionRepository: UserSessionRepository, userSession: UserSession) {
        self.userSessionRepository = userSessionRepository
        self.userSession = userSession
    }
    
    func numberOfRows() -> Int {
        fatalError()
    }
    
    func viewModelForRow(at indexPath: IndexPath) -> MemberCellViewModel {
        fatalError()
    }
    
    func userProfileForRow(at indexPath: IndexPath) -> UserProfile {
        fatalError()
    }
    
    func isUserSelected(userProfile: UserProfile) -> Bool {
        fatalError()
    }
    
    
    func getAllMembers() {
        fatalError()
    }
    
    func removeMember() {
        
    }
}
