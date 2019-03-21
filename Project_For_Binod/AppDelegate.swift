//
//  AppDelegate.swift
//  Project_For_Binod
//
//  Created by guest on 2017/12/25.
//  Copyright © 2017年 JEC. All rights reserved.
//

import UIKit
import CoreData

//Global Variable that can be used from any class
let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
//Global variable to store user data
var user : NSDictionary?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    //Flag for error View
    var isNotificationViewShowing : Bool = false


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Changing the color of the Navigation Bar
        UINavigationBar.appearance().barTintColor = UIColor(hex: "8F6593")//Main Theme Purple Color
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        UINavigationBar.appearance().tintColor = UIColor.white
        UIApplication.shared.statusBarStyle = .lightContent
        
        //Automatic Login if User info is Available
        //Checking For user info
        let defaultUser = UserDefaults.standard
        user = defaultUser.object(forKey: "json") as? NSDictionary
        
        //if user info is found then log in
        if let savedUser = user{
            if savedUser["id"] != nil {
                login()
            }
        }
       
     
        
        return true
    }
  
  
  

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

