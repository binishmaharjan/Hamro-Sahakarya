//
//  AppDelegate.swift
//  Project_For_Binod
//
//  Created by guest on 2017/12/25.
//  Copyright © 2017年 JEC. All rights reserved.
//

import UIKit
import Firebase

//Global variable to store user data
var user : NSDictionary?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  let injectionContainer = AppDependencyContainer()
  
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Firebase Server
    setupFirebaseServer(application,launchOptions)
    
    let mainViewControlelr = injectionContainer.makeMainViewController()
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.makeKeyAndVisible()
    window?.rootViewController = mainViewControlelr
    
    return true
  }
  
}



extension AppDelegate{
  private func setupFirebaseServer(_ application : UIApplication, _ launchOptions: [UIApplication.LaunchOptionsKey: Any]?){
    var firebasePlistName = ""
    
    if IS_DEBUG {
      firebasePlistName = "GoogleService-Info-dev"
    } else {
      firebasePlistName = "GoogleService-Info"
    }
    if let path = Bundle.main.path(forResource: firebasePlistName, ofType: "plist"), let firbaseOptions = FirebaseOptions(contentsOfFile: path) {
      FirebaseApp.configure(options: firbaseOptions)
    }
    
    //Setup Session user
    self.setupSessionUser()
  }
  
  private func setupSessionUser(){
//    guard let uid = HSSessionManager.shared.uid
//      else {
//        Dlog("NO USER LOGGED IN")
//        return
//    }
//      HSSessionManager.shared.userLoggedIn(uid: uid)
  }
}
