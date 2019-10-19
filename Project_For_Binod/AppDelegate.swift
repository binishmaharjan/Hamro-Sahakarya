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
    //Flag for error View
    var isNotificationViewShowing : Bool = false


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      //Firebase Server
      setupFirebaseServer(application,launchOptions)
      
      window = UIWindow(frame: UIScreen.main.bounds)
      window?.makeKeyAndVisible()
      window?.rootViewController = UIViewController()

      
      
      //TODO:Version 1 Login Delete this
//        //Automatic Login if User info is Available
//        //Checking For user info
//        let defaultUser = UserDefaults.standard
//        user = defaultUser.object(forKey: "json") as? NSDictionary
//
//        //if user info is found then log in
//        if let savedUser = user{
//            if savedUser["id"] != nil {
//                login()
//            }
//        }

        return true
    }
  
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}


//TODO : Delete this
extension AppDelegate{
  //Notification
  func errorView(message :String, color : UIColor){
    if isNotificationViewShowing == false{
      isNotificationViewShowing = true
      
      //Creating the red view
      let notificationView_height = (self.window?.bounds.height)! / 14.2
      let notificationView_y : CGFloat = 0 - notificationView_height
      let colorNotification = color
      
      let notifiactionView : UIView = UIView(frame : CGRect(x: 0, y: notificationView_y, width: (self.window?.bounds.width)!, height: notificationView_height))
      notifiactionView.backgroundColor = colorNotification
      self.window?.addSubview(notifiactionView)
      
      //Error Label
      let notificationLabel_width = notifiactionView.bounds.width
      let notificationLabel_height = notifiactionView.bounds.height + UIApplication.shared.statusBarFrame.height / 2
      
      let notificationLabel = UILabel()
      notificationLabel.frame.size.width = notificationLabel_width
      notificationLabel.frame.size.height = notificationLabel_height
      notificationLabel.numberOfLines = 0
      notificationLabel.text = message
      notificationLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
      notificationLabel.textColor = .white
      notificationLabel.textAlignment = .center
      notifiactionView.addSubview(notificationLabel)
      
      //Animation
      UIView.animate(withDuration: 0.2, animations: {
        notifiactionView.frame.origin.y = 0
      }, completion: { (finished) in
        if finished{
          UIView.animate(withDuration: 0.1, delay: 2, options: .curveLinear, animations: {
            notifiactionView.frame.origin.y = notificationView_y
          }, completion: { (finished) in
            notifiactionView.removeFromSuperview()
            notificationLabel.removeFromSuperview()
            self.isNotificationViewShowing = false
          })
        }
      })
      
    }
  }
  
  //Login to the home page
  func login(){
    //Initiatingt the storyboard
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    //Initiating the tab bar
    let tabBar = storyBoard.instantiateViewController(withIdentifier: "tabBar")
    //changing the root view to tab bar
    window?.rootViewController = tabBar
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
