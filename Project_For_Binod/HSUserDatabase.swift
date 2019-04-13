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
  func downloadUserData(uid:String,completion:((HSMemeber?,Error?)->())?)
}

extension HSUserDatabase{
  //Writing User Info To FIreStore
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
  
  //Downloading Current User Info
  func downloadUserData(uid:String,completion:((HSMemeber?,Error?)->())?){
    if let savedUser = cacheUsers.object(forKey: NSString(string: uid)) as? Wrapper<HSMemeber>{
      let user = savedUser.value
      completion?(user,nil)
      return
    }
    
    let ref = Firestore.firestore().collection(DatabaseReference.MEMBERS_REF).document(uid)
    ref.getDocument { (snapshot, error) in
      if let error = error{
        completion?(nil,error)
        return
      }
      
      guard let snapshot = snapshot else {
        completion?(nil,NO_SNAPSHOT_ERROR)
        return
      }
      
      guard let data = snapshot.data() else {
        completion?(nil,EMPTY_DATA_ERROR)
        return
      }
      
      do{
        let userInfo = try FirestoreDecoder().decode(HSMemeber.self,from: data)
        cacheUsers.setObject(Wrapper<HSMemeber>(_struct: userInfo), forKey: userInfo.uid as NSString)
        completion?(userInfo,nil)
      }catch{
        completion?(nil,error)
      }
    }
  }
}
