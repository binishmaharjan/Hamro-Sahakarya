//
//  Macros.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/03/22.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit

#if DEBUG
let IS_DEBUG = true
#else
let IS_DEBUG = false
#endif

//Log for Debug
func Dlog(_ obj: Any? = nil, file:String = #file, function:String = #function, line: Int = #line){
  #if DEBUG
  var filename:NSString = file as NSString
  filename = filename.lastPathComponent as NSString
  if let obj = obj{
    print("[File:\(filename) Func:\(function) Line:\(line)] : \(obj)")
  }else{
    print("[File:\(filename) Func:\(function) Line:\(line)]")
  }
  #endif
}

//Log for Release
func Alog(_ obj: Any? = nil, file: String = #file, function: String = #function, line: Int = #line){
  var filename: NSString = file as NSString
  filename = filename.lastPathComponent as NSString
  if let obj = obj{
    NSLog("[File:\(filename) Func:\(function) Line:\(line)] : \(obj)")
  }else{
    NSLog("[File:\(filename) Func:\(function) Line:\(line)]")
  }
}

//Localize Text
func LOCALIZE(_ text: String) -> String{
  return NSLocalizedString(text, comment: "")
}

//Generate Random Number
func randomID(length: Int) -> String {
  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  return String((0...length-1).map{ _ in letters.randomElement()! })
}


let appDelegate = UIApplication.shared.delegate as! AppDelegate
let SAFE_AREA_TOP_INSETS = UIApplication.shared.keyWindow?.safeAreaInsets.top
let HAMRO_SAHAKARYA = "hamro_sahakarya"


//MARK:CACHE
let cacheUsers = NSCache<NSString, AnyObject>()

//MARK:Errors
let NO_RESULT_ERROR = NSError.init(domain: "No Result", code: -1, userInfo: nil)
let NO_SNAPSHOT_ERROR = NSError.init(domain: "No Snapshot", code: -10, userInfo: nil)
let EMPTY_DATA_ERROR = NSError.init(domain: "Empty Data", code: -20, userInfo: nil)

func createDropDownAlert(message:String,type:HSDropDownType){
  let dropDown = HSDropDownNotification()
  dropDown.text = LOCALIZE(message)
  dropDown.type = type
  appDelegate.window?.addSubview(dropDown)
}

//MARK:Firestore Constants
class DatabaseReference{
  static let HAMRO_SAHAKARYA_REF = "hamro_sahakarya"
  static let DETAIL_REF = "detail"
  static let TOTAL_BALANCE = "total_balance"
  static let CURRENT_BALANCE = "current_balance"
  static let EXTRA = "extra"
  static let EXPENSES = "expenses"
  static let TOTAL_LOAN_GIVEN = "total_loan_given"
  
  static let MEMBERS_REF = "members"
  static let USERNAME = "username"
  static let UID = "uid"
  static let EMAIL = "email"
  static let STATUS = "status"
  static let COLORHEX = "colorhex"
  static let ICON_URL = "icon_url"
  static let MY_ACCOUNT_REF = "my_account"
  static let LOAN_TAKEN = "loan_taken"
  static let BALANCE = "balance"
  static let KEYWORD = "keyword"
  
  static let LOGS_REF = "logs"
  static let LOG_ID = "log_id"
  static let LOG_OWNER = "log_owner"
  static let LOG_CREATOR = "log_creator"
  static let AMOUNT = "amount"
  static let DESCRIPTION = "description"
  static let LOG_TYPE = "log_type"
  static let DATE_CREATED = "date_created"
}

class StorageReference{
  static let USER_PROFILE = "user_profile"
  static let PROFILE_IMAGE = "profile_image.jpg"
}
