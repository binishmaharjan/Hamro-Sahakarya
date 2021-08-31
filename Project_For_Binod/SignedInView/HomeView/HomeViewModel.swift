//
//  HomeViewModel.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/04/25.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol HomeViewModelProtocol {
    var myBalance: Observable<String> { get }
    var loanTaken: Observable<String> { get }
    var dateJoined: Observable<String> { get }
    var status: Observable<Status> { get }
    var username: Observable<String> { get }
    var email: Observable<String> { get }
    var membersCount: Observable<Int> { get }
    var isAdmin: Observable<Bool> { get }
    var homeContentView: BehaviorRelay<HomeContentView> { get }
    var apiState: Driver<State> { get }
    var allMembers: BehaviorRelay<[UserProfile]> { get }
    var groupDetail: BehaviorRelay<GroupDetail> { get }
    var noticeRelay: BehaviorRelay<Notice> { get }
    
    func fetchData()
}

struct HomeViewModel: HomeViewModelProtocol {

    private let homeViewResponder: HomeViewResponder
    private let userSessionRepository: UserSessionRepository
    private let userSession: BehaviorRelay<UserProfile>
    private let numberFormatter: NumberFormatter = NumberFormatter()
    private let dispatchGroup: DispatchGroup = DispatchGroup()
    
    private let fetchDataFailed: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    let allMembers: BehaviorRelay<[UserProfile]> = BehaviorRelay(value: [])
    let groupDetail: BehaviorRelay<GroupDetail> = BehaviorRelay(value: GroupDetail(extra: 0, expenses: 0))
    let noticeRelay: BehaviorRelay<Notice> = BehaviorRelay(value: Notice.blankNotice)
    let loanTaken: Observable<String>
    let dateJoined: Observable<String>
    let status: Observable<Status>
    let myBalance: Observable<String>
    let username: Observable<String>
    let email: Observable<String>
    let membersCount: Observable<Int>
    let isAdmin: Observable<Bool>
    
    var homeContentView: BehaviorRelay<HomeContentView> = BehaviorRelay(value: .accountDetail)
    
    @PropertyBehaviourRelay<State>(value: .idle)
    var apiState: Driver<State>
    
    init(homeViewResponder: HomeViewResponder, userSessionRepository: UserSessionRepository, userSession: UserSession) {
        self.homeViewResponder = homeViewResponder
        self.userSessionRepository = userSessionRepository
        
        self.userSession = userSession.profile
        self.loanTaken = self.userSession.map { $0.loanTaken.currency }
        self.myBalance = self.userSession.map { $0.balance.currency }
        self.dateJoined = self.userSession.map { $0.dateCreated.toDateAndTime.toGegorianMonthDateYearString }
        self.status = self.userSession.map { $0.status }
        self.username = self.userSession.map { $0.username }
        self.email = self.userSession.map { $0.email }
        self.membersCount = allMembers.map { $0.count }
        self.isAdmin = self.userSession.map { $0.status == .admin }
    }
}

// MARK: Api
extension HomeViewModel {
    
    func fetchData() {
        indicateLoading()
        
        dispatchGroup.enter()
        fetchAllMembers()
        
        dispatchGroup.enter()
        fetchExtraIncomeAndExpenses()
        
        dispatchGroup.enter()
        fetchNotice()
        
        dispatchGroup.notify(queue: .main) {
            if self.fetchDataFailed.value {
                self.fetchDataFailed.accept(false)
                self._apiState.accept(.error(HSError.unknown))
            } else {
                self._apiState.accept(.completed)
                self.udpateUserSession()
            }
        }
    }
    
    private func fetchAllMembers() {
        userSessionRepository
            .getAllMembers()
            .done(indicateFetchAllMembersSuccessful(members:))
            .catch(indicateError(error:))
    }
    
    private func fetchExtraIncomeAndExpenses() {
        userSessionRepository.fetchExtraAndExpenses()
            .done(indicateFetchExtraIncomeAndExpensesSuccessful(detail:))
            .catch(indicateError(error:))
    }
    
    private func fetchNotice() {
        userSessionRepository.fetchNotice()
            .done(indicateFetchNoticeSuccessful(notice:))
            .catch(indicateError(error:))
    }

    private func udpateUserSession() {
        let selfUser = allMembers.value.filter { $0.email == userSession.value.email }.first
        
        guard let unwrappedSelfUser =  selfUser else { return }
        _ = userSessionRepository.saveUserSession(userProfile: unwrappedSelfUser).done { (newValue) in
            self.userSession.accept(newValue.profile.value)
        }
    }
    
    private func indicateLoading() {
        _apiState.accept(.loading)
    }
    
    private func indicateFetchAllMembersSuccessful(members: [UserProfile]) {
        allMembers.accept(members)
        dispatchGroup.leave()
    }
    
    private func indicateFetchExtraIncomeAndExpensesSuccessful(detail: GroupDetail) {
        groupDetail.accept(detail)
        dispatchGroup.leave()
    }
    
    private func indicateFetchNoticeSuccessful(notice: Notice) {
        noticeRelay.accept(notice)
        dispatchGroup.leave()
    }
    
    private func indicateError(error: Error) {
        fetchDataFailed.accept(true)
        _apiState.accept(.error(error))
        dispatchGroup.leave()
    }
}
