//
//  UserProfileCoding.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/11/09.
//  Copyright © 2019 JEC. All rights reserved.
//

import Foundation

protocol UserProfileCoding {
  
  func encode(userSession: UserSession) -> Data
  func decode(data: Data) -> UserSession
}
