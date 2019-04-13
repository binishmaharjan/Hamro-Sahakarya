//
//  HSLogType.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/03/30.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit


enum HSLogType:String{
  //Amount
  case joined = "joined"
  case left = "left"
  case loanGiven = "loan_given"
  case loanReturned = "loan_returned"
  case loanRequested = "loan_requested"
  case monthlyFee = "monthly_fee"
  case fee = "fee"
  case extra = "extra"
  case expenses = "expenses"
  
  
  //Non Amount
  case madeAdmin = "made_admin"
  case removedAdmin = "removed_admin"
}
