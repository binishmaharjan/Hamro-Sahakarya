//
//  Macros.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/10/19.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit

#if DEBUG
let IS_DEBUG = true
#else
let IS_DEBUG = false
#endif

// MARK: Log For Debug
/// Prints to console on debug build configuration
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

// MARK: Log For Release
/// Prints to console on debug realease configuration
func Alog(_ obj: Any? = nil, file: String = #file, function: String = #function, line: Int = #line){
    var filename: NSString = file as NSString
    filename = filename.lastPathComponent as NSString
    if let obj = obj{
        NSLog("[File:\(filename) Func:\(function) Line:\(line)] : \(obj)")
    }else{
        NSLog("[File:\(filename) Func:\(function) Line:\(line)]")
    }
}

// MARK: Global Variables
let safeAreaTopInsets = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0.0
let appDelegate = UIApplication.shared.delegate as! AppDelegate

// MARK: FireStore Database References
final class DatabaseReference{
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
    
    static let NOTICE_REF = "notice"
}

// MARK: Firebase Storage Reference
final class StorageReference{
    static let USER_PROFILE = "user_profile"
    static let PROFILE_IMAGE = "profile_image.jpg"
    
    static let TERMS_AND_CONDITION_REF = "terms_and_condition"
    static let TERMS_AND_CONDITION_PDF = "terms_and_conditions.pdf"
}
