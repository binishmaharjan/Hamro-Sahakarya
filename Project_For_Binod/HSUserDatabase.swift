//
//  HSFireStoreWrite.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/03/26.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import FirebaseFirestore
import CodableFirebase


protocol HSUserDatabase{
  func writeUserInfoToFireStore(uid:String,email:String,username:String,initialAmount:Int,
                                keyword:String,status:String,colorHex:String,completion:((Error?)->())?)
}

extension HSUserDatabase{
  func writeUserInfoToFireStore(uid:String,email:String,username:String,initialAmount:Int,
                                keyword:String,status:String,colorHex:String,completion:((Error?)->())?){
    
    let user = HSMemeber.init(uid: uid,
                              username: username,
                              email: email,
                              status: status,
                              colorHex: colorHex,
                              iconUrl: "",
                              dateCreated: HSDate.dateToString(),
                              keyword:keyword, loanTaken: 0,
                              balance: initialAmount,
                              dateUpdated: HSDate.dateToString()
                              )
    
    do{
      let userData = try FirestoreEncoder().encode(user) as [String:Any]
      
      DispatchQueue.global(qos: .default).async {
        //Member Data
        let docRef = Firestore.firestore().collection(DatabaseReference.MEMBERS_REF).document(uid)
        docRef.setData(userData, completion: { (error) in
          if let error = error{
            DispatchQueue.main.async{completion?(error)}
            return
          }
          completion?(nil)
        })
      }
    }catch{
      completion?(error)
    }
  }
}
