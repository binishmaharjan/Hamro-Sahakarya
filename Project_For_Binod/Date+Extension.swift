//
//  Date+Extension.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/11/10.
//  Copyright © 2019 JEC. All rights reserved.
//

import Foundation


// MARK: Date To String
extension Date {
  
  var toString: String {
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    return formatter.string(from: self)
  }
    
    var toGegorianMonthDateYearString: String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter.string(from: self)
    }
    
}

// MARK: String To Date
extension String {
  
  var toDateAndTime: Date {
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    if let date = formatter.date(from: self) {
      return date
    } else {
      return Date()
    }
  }
  
  var toDate: Date {
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.dateFormat = "yyyy-MM-dd"
    if let date = formatter.date(from: self) {
      return date
    } else {
      return Date()
    }
  }
  
}
