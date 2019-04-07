//
//  HSNotificationManager.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/03/22.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit


class HSNotificationManager:NSObject{
  
  //MARK: - Base Remove
  static func remove(_ observer:Any){
    NotificationCenter.default.removeObserver(observer)
  }
  
  //MARK: - Base Post
  private static func post(notificationName: NSNotification.Name, object:Any?, userInfo: [AnyHashable: Any]?){
    NotificationCenter.default.post(name: notificationName, object: object, userInfo : userInfo)
  }
  
  private static func post(name: String, object: Any?, userInfo: [AnyHashable : Any]? = nil){
    self.post(notificationName: NSNotification.Name(name), object: object, userInfo: userInfo)
  }
  
  //MARK: - Base Receive
  private static func receive(notificationName: NSNotification.Name, observer: Any, selector: Selector){
    NotificationCenter.default.addObserver(observer, selector: selector, name: notificationName, object: nil)
  }
  private static func receive(name:String, observer: Any,selector:Selector){
    self.receive(notificationName: NSNotification.Name(name), observer: observer, selector: selector)
  }
}

 //MARK: - Keyboard
extension HSNotificationManager{
  static func receive(keyboardDidChangeFrame observer:Any, selector:Selector) {
    let name = UIResponder.keyboardDidChangeFrameNotification
    self.receive(notificationName: name, observer: observer, selector: selector)
  }
  static func receive(keyboardDidHide observer:Any, selector:Selector) {
    let name = UIResponder.keyboardDidHideNotification
    self.receive(notificationName: name, observer: observer, selector: selector)
  }
  static func receive(keyboardWillChangeFrame observer:Any, selector:Selector) {
    let name = UIResponder.keyboardWillChangeFrameNotification
    self.receive(notificationName: name, observer: observer, selector: selector)
  }
  static func receive(keyboardWillHide observer:Any, selector:Selector) {
    let name = UIResponder.keyboardWillHideNotification
    self.receive(notificationName: name, observer: observer, selector: selector)
  }
  static func receive(keyboardWillShow observer:Any, selector:Selector) {
    let name = UIResponder.keyboardWillShowNotification
    self.receive(notificationName: name, observer: observer, selector: selector)
  }
}

extension HSNotificationManager{
  //CURRENT_USER_INFO_DOWNLOADED
  private static let CURRENT_USER_INFO_DOWNLOADED = "CURRENT_USER_INFO_DOWNLOADED"
  static func postCurrentUserInfoDownloaded(){self.post(name: CURRENT_USER_INFO_DOWNLOADED, object: nil)}
  static func receive(currentUserInfoDownloaded observer:Any,selector:Selector)
  {self.receive(name: CURRENT_USER_INFO_DOWNLOADED, observer: observer, selector: selector)}
}
