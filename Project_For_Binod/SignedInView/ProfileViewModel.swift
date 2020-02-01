//
//  ProfileViewModel.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/02/01.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation
enum ProfileRow {
  case top(ProfileTopCellViewModel)
  
  // User
  case changePicture
  case changePassword
  case members
  
  // Admin
  case makeAdmin
  case removeAdmin
  case extra
  case expenses
  case monthlyFee
  
  // Others
  case termsOfAgreement
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
    case .termsOfAgreement:
      return "Terms of Agreement"
    case .license:
      return "Licence"
    case .logout:
      return "Logout"
    case .makeAdmin:
      return "Make Admin"
    case .removeAdmin:
      return "Remove Admin"
    case .extra:
      return "Add Extra"
    case .expenses:
      return "Add Expenses"
    case .monthlyFee:
      return "Monthly Fee"
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
  
  func signOut()
  func numberOfRows(in section: Int) -> Int
  func row(for indexPath: IndexPath) -> ProfileRow
}

struct DefaultProfileViewModel: ProfileViewModel {

  // MARK: Properties
  let userSession: UserSession
  let notSignedInResponder: NotSignedInResponder
  let userSessionRepository: UserSessionRepository
  
  // Data Source
  var profileSections: [ProfileSection] {
    // Making Section
    let topSection =  ProfileSection(rows: [.top(DefaultProfileTopCellViewModel(userSession: userSession))])
    let userSection = ProfileSection(rows: [.changePicture, .changePassword, .members])
    let adminSection = ProfileSection(rows: [.makeAdmin, .removeAdmin, .monthlyFee, .extra, .expenses])
    let otherSection = ProfileSection(rows: [.termsOfAgreement, .license, .logout])
    
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
  
  // MARK: Init
  init(userSession: UserSession,
       notSignedInResponder: NotSignedInResponder,
       userSessionRepository: UserSessionRepository) {
    self.userSession = userSession
    self.notSignedInResponder = notSignedInResponder
    self.userSessionRepository = userSessionRepository
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
    
  }
  
  private func indicateError(error: Error) {
    
  }
}