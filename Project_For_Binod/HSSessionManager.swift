//
//  HSSessionManager.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/04/07.
//  Copyright © 2019 JEC. All rights reserved.
//

import Foundation
import FirebaseAuth


class HSSessionManager{
  //MARK:Singleton
  private init(){}
  static let shared = HSSessionManager()
  
  //User
  var user:HSMemeber?
  
  var uid:String?{
    return Auth.auth().currentUser?.uid
  }
}

//MARK:User Logged In
extension HSSessionManager:HSUserDatabase{
  func userLoggedIn(uid:String,completion:(()->())?=nil){
    self.downloadUserData(uid: uid) { (user, error) in
      if let error = error{
        Dlog(error.localizedDescription)
        return
      }
      self.user = user
      self.thowUserInfoDidDownloadedNotification()
      completion?()
      Dlog(user)
    }
  }
  
  private func thowUserInfoDidDownloadedNotification(){
    HSNotificationManager.postCurrentUserInfoDownloaded()
  }
}
