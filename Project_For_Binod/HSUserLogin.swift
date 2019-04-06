//
//  HSUserLogin.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/04/04.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import FirebaseAuth


protocol HSUserLogin{
  func loginWithEmail(email:String,password:String,completion:((Error?)->())?)
}


extension HSUserLogin{
  func loginWithEmail(email:String,password:String,completion:((Error?)->())?){
    Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
      if let error = error{
        completion?(error)
        return
      }
      completion?(nil)
    }
  }
}
