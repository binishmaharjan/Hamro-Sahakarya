//
//  UserProfile.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/10/19.
//  Copyright © 2019 JEC. All rights reserved.
//

import Foundation
import CodableFirebase

struct UserProfile: Equatable, Codable {
  let uid: String
  let username: String
  let email: String
  let status: Status
  let colorHex: String
  let iconUrl: String?
  let dateCreated: String
  let keyword: String
  
  //Account
  let loanTaken: Int?
  let balance: Int?
  let dateUpdated: String?
  
  private enum CodingKeys:String, CodingKey {
     case uid
     case username
     case email
     case status
     case colorHex = "color_hex"
     case iconUrl = "icon_url"
     case dateCreated = "date_created"
     case loanTaken = "loan_taken"
     case balance
     case dateUpdated = "data_updated"
     case keyword
   }
}
