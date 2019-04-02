//
//  HSLog.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/03/30.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit


struct HSLog:Codable{
  let lodId:String
  let logOwner:String?
  let logCreator:String?
  let amount:Int?
  let logType:String?
  let dateCreated:String?

  private enum CodingKeys:String,CodingKey{
    case lodId = "log_id"
    case logOwner = "log_owner"
    case logCreator = "log_creator"
    case amount
    case logType = "log_type"
    case dateCreated = "date_created"
  }
}
