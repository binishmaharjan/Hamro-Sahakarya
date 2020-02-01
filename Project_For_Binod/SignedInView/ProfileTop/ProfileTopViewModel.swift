//
//  ProfileTopViewModel.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/02/01.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation

protocol ProfileTopCellViewModel {
  var imageUrl: URL? { get }
  var fullname: String { get }
  var status: Status { get }
}

struct DefaultProfileTopCellViewModel: ProfileTopCellViewModel {
  private let userSession: UserSession
  
  var imageUrl: URL? {
    let imageString = userSession.profile.iconUrl ?? ""
    return URL(string: imageString)
  }
  
  var fullname: String {
    return userSession.profile.username ?? ""
  }
  
  var status: Status {
    return userSession.profile.status ?? .member
  }
  
  init(userSession: UserSession) {
    self.userSession = userSession
  }
  
}
