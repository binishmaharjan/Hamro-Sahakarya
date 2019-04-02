//
//  HSDate.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/03/30.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit

class HSDate{
  static func dateToString()->String{
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    return formatter.string(from: Date())
  }
  
  static func stringToDateTime(string : String)->Date{
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    if let date = formatter.date(from: string){
      return date
    }else{
      return Date()
    }
  }
  
  static func stringToDate(string : String)->Date{
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.dateFormat = "yyyy-MM-dd"
    if let date = formatter.date(from: string){
      return date
    }else{
      return Date()
    }
  }
}
