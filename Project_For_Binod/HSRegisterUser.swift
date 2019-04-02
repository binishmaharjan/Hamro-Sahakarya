//
//  HSRegisterUser.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/03/25.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import FirebaseAuth


protocol HSRegisterUser{
  func resgisterEmailUser(email:String,password:String,username:String,initialAmount:Int,
                          status:String,colorHex:String,completion:((String?,Error?)->())?)
}


extension HSRegisterUser{
  func resgisterEmailUser(email:String,password:String,username:String,initialAmount:Int,
                          status:String,colorHex:String,completion:((String?,Error?)->())?){
    Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
      if let error = error{
        completion?(nil,error)
        return
      }
      
      guard let result = result else{
        completion?(nil,NO_RESULT_ERROR)
        return
      }
      
      let user = result.user
      let changeRequest = user.createProfileChangeRequest()
      changeRequest.displayName = username
      changeRequest.commitChanges(completion: { (error) in
        if let error = error{
          completion?(nil, error)
          return
        }
      })
      
      //Getting user id
      let uid = user.uid
      completion?(uid,nil)
      
    }
  }
}
