//
//  HSGroupDetail.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/04/11.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit

struct HSGroup:Codable{
  var totalBalance:Int?
  var currentBalance:Int?
  var members:Int?
  var extra:Int?
  var expenses:Int?
  
  enum CodingKeys:String,CodingKey{
    case totalBalance = "total_balance"
    case currentBalance = "current_balance"
    case members
    case extra
    case expenses
  }
}
