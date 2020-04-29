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
    var removeMemberSuccessful: Driver<Bool> { get }
    
    func fetchAllMembers()
    func removeMember()
    
    func numberOfRows() -> Int
    func viewModelForRow(at indexPath: IndexPath) -> MemberCellViewModel
    func userProfileForRow(at indexPath: IndexPath) -> UserProfile
    func isUserSelected(userProfile: UserProfile) -> Bool
}

struct RemoveMemberViewModel: RemoveMemberViewModelProtocol {
    
    private let userSessionRepository: UserSessionRepository
    private let userSession: UserSession
    private var allMembers: BehaviorRelay<[UserProfile]> = BehaviorRelay(value: [])
    
    var selectedMember: BehaviorRelay<UserProfile?> = BehaviorRelay(value: nil)
    
    @PropertyBehaviourRelay<State>(value: .idle)
    var apiState: Driver<State>
    @PropertyBehaviourRelay<Bool>(value: false)
    var removeMemberSuccessful: Driver<Bool>
    
    init(userSessionRepository: UserSessionRepository, userSession: UserSession) {
        self.userSessionRepository = userSessionRepository
        self.userSession = userSession
    }
    
    func numberOfRows() -> Int {
        return allMembers.value.count
    }
    
    func viewModelForRow(at indexPath: IndexPath) -> MemberCellViewModel {
        return DefaultMemberCellViewModel(profile: userProfileForRow(at: indexPath))
    }
    
    func userProfileForRow(at indexPath: IndexPath) -> UserProfile {
        return allMembers.value[indexPath.row]
    }
    
    func isUserSelected(userProfile: UserProfile) -> Bool {
        return userProfile == selectedMember.value
    }
    
}

// MARK: Api
extension RemoveMemberViewModel {
    
    func fetchAllMembers() {
        indicateLoading()
        
        userSessionRepository
            .getAllMembers()
            .done(indicateGetMemberSuccessful(members:))
            .catch(indicateError(error:))
    }
    
    func removeMember() {
        indicateLoading()
        
        guard let selectedMember = self.selectedMember.value else {
            indicateError(error: HSError.unknown)
            return
        }
        
        userSessionRepository
            .removeMember(admin: userSession.profile, member: selectedMember)
            .done(indicateGetRemoveMemberSuccessful)
            .catch(indicateError(error:))
    }
    
    private func indicateLoading() {
        _removeMemberSuccessful.accept(false)
        _apiState.accept(.loading)
    }
    
    private func indicateGetMemberSuccessful(members: [UserProfile]) {
        let allMembersExcludingSelf = members.filter { !($0.email == userSession.profile.email) }
        allMembers.accept(allMembersExcludingSelf)
        _apiState.accept(.completed)
    }
    
    private func indicateGetRemoveMemberSuccessful() {
        _removeMemberSuccessful.accept(true)
        selectedMember.accept(nil)
        _apiState.accept(.completed)
    }
    
    private func indicateError(error: Error) {
        _apiState.accept(.error(error))
    }
}
