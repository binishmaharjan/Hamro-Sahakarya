//
//  HSSessionManager.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/04/07.
//  Copyright © 2019 JEC. All rights reserved.
//

import Foundation
import FirebaseFirestore


class HSSessionManager{
  //MARK:Singleton
  private init(){}
  static let shared = HSSessionManager()
  
  //User
  var user:HSMemeber?
}

//MARK:User Logged In
extension HSSessionManager:HSUserDatabase{
  func userLoggedIn(uid:String){
    self.downloadCurrentUserData(uid: uid) { (user, error) in
      if let error = error{
        Dlog(error.localizedDescription)
        return
      }
      self.user = user
    }
  }
  
  private func thowUserInfoDidDownloadedNotification(){
    HSNotificationManager.postCurrentUserInfoDownloaded()
  }
}
