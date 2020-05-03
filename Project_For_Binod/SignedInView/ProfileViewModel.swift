//
//  ProfileViewModel.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/02/01.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum ProfileRow {
    case top(ProfileTopCellViewModel)
    
    // User
    case changePicture
    case changePassword
    case members
    
    // Admin
    case changeStatus
    case extraAndExpenses
    case monthlyFee
    case loanMember
    case loanReturned
    case removeMember
    
    // Others
    case termsAndCondition
    case license
    case logout
    
    var title: String {
        switch self {
            
        case .top(_):
            return ""
        case .changePicture:
            return "Change Picture"
        case .changePassword:
            return "Change Password"
        case .members:
            return "Members"
        case .termsAndCondition:
            return "Terms And Condition"
        case .license:
            return "Licence"
        case .logout:
            return "Logout"
        case .changeStatus:
            return "Change Status"
        case .extraAndExpenses:
            return "Extra Income And Expenses"
        case .monthlyFee:
            return "Monthly Fee"
        case .loanMember:
            return "Loan a Member"
        case .loanReturned:
            return "Loan Returned"
        case .removeMember:
            return "Remove Member"
        }
    }
}

struct ProfileSection {
    let rows: [ProfileRow]
}


protocol ProfileViewModel {
    var userSession: UserSession { get }
    var notSignedInResponder: NotSignedInResponder { get }
    var numberOfSection: Int { get }
    var lastSection: Int { get }
    var state: Driver<State> { get }
    
    func signOut()
    func navigate(to view: ProfileMainView)
    func numberOfRows(in section: Int) -> Int
    func row(for indexPath: IndexPath) -> ProfileRow
}

typealias ProfileViewResponder = ProfileMainViewModel

struct DefaultProfileViewModel: ProfileViewModel {
    
    // MARK: Properties
    let userSession: UserSession
    let notSignedInResponder: NotSignedInResponder
    let userSessionRepository: UserSessionRepository
    let profileViewResponder: ProfileViewResponder
    
    // Data Source
    var profileSections: [ProfileSection] {
        // Making Section
        let topSection =  ProfileSection(rows: [.top(DefaultProfileTopCellViewModel(userSession: userSession))])
        let userSection = ProfileSection(rows: [.changePicture, .changePassword, .members])
        let adminSection = ProfileSection(rows: [.changeStatus, .monthlyFee, .extraAndExpenses, .loanMember, .loanReturned,.removeMember])
        let otherSection = ProfileSection(rows: [.termsAndCondition, .license, .logout])
        
        var section: [ProfileSection] = []
        
        section.append(topSection)
        section.append(userSection)
        if userSession.isAdmin {
            section.append(adminSection)
        }
        section.append(otherSection)
        
        return section
    }
    
    var numberOfSection: Int {
        return profileSections.count
    }
    
    var lastSection: Int {
        return numberOfSection - 1
    }
    
    @PropertyBehaviourRelay<State>(value: .idle)
    var state: Driver<State>
    
    // MARK: Init
    init(userSession: UserSession,
         notSignedInResponder: NotSignedInResponder,
         userSessionRepository: UserSessionRepository,
         profileViewResponder: ProfileViewResponder) {
        self.userSession = userSession
        self.notSignedInResponder = notSignedInResponder
        self.userSessionRepository = userSessionRepository
        self.profileViewResponder = profileViewResponder
    }
    
    // MARK: Methods
    func signOut() {
        userSessionRepository.signOut(userSession: userSession)
            .done(indicateSignoutSuccessful)
            .catch(indicateError)
    }
    
    func numberOfRows(in section: Int) -> Int {
        return profileSections[section].rows.count
    }
    
    func row(for indexPath: IndexPath) -> ProfileRow {
        return profileSections[indexPath.section].rows[indexPath.row]
    }
    
    private func indicateSignoutSuccessful(userSession: UserSession) {
        notSignedInResponder.notSignedIn()
    }
    
    private func indicateError(error: Error) {
        _state.accept(.error(error))
    }
}

extension DefaultProfileViewModel {
    func navigate(to view: ProfileMainView) {
        profileViewResponder.navigate(to: view)
    }
    
}
