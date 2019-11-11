//
//  NewAccount.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/11/10.
//  Copyright © 2019 JEC. All rights reserved.
//

import Foundation

struct NewAccount: Codable {
  
  let username: String
  let email: String
  let status: String
  let colorHex: String
  let dateCreated: String
  let keyword: String
  let initialAmount: Int
  
}