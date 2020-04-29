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
}

struct HomeViewModel: HomeViewModelProtocol {

    private let homeViewResponder: HomeViewResponder
    private let userSessionRepository: UserSessionRepository
    private var userSession: BehaviorRelay<UserProfile>
    
    let loanTaken: Observable<String>
    let dateJoined: Observable<String>
    let status: Observable<Status>
    let myBalance: Observable<String>
    let username: Observable<String>
    let email: Observable<String>
    
    init(homeViewResponder: HomeViewResponder, userSessionRepository: UserSessionRepository, userSession: UserSession) {
        self.homeViewResponder = homeViewResponder
        self.userSessionRepository = userSessionRepository
        
        self.userSession = BehaviorRelay(value: userSession.profile)
        self.loanTaken = self.userSession.map { "¥\($0.loanTaken)" }
        self.myBalance = self.userSession.map { "¥\($0.balance)" }
        self.dateJoined = self.userSession.map { $0.dateCreated.split(separator: " ").first }.map { String( $0 ?? "") }
        self.status = self.userSession.map { $0.status }
        self.username = self.userSession.map { $0.username }
        self.email = self.userSession.map { $0.email }
    }
}
