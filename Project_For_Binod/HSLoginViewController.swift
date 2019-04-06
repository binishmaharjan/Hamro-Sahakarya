//
//  HSLoginViewController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/03/22.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import TinyConstraints

class HSLoginViewController:HSViewController{
  //MARK:Variables
  private weak var mainView:HSLoginView?
  private var mainViewBottomConstraints:Constraint?
  
  private let LOGIN_USERNAME:String = "admin"
  private let LOGIN_PASSWORD:String = "admin"
  
  //MARK:Initializer
  override func didInit() {
    super.didInit()
    outsideSafeAreaTopViewTemp?.backgroundColor = HSColors.white
    outsideSafeAreaBottomViewTemp?.backgroundColor = HSColors.white
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setup()
    self.setupConstraints()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.setupNotification()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.tearDownNotification()
  }
  
  //MARK:Setup
  private func setup(){
    let mainView = HSLoginView()
    self.mainView = mainView
    mainView.delegate = self
    self.view.addSubview(mainView)
  }
  
  private func setupConstraints(){
    guard let mainView = self.mainView
      else {return}
    mainView.edgesToSuperview(excluding: .bottom,usingSafeArea:true)
    mainViewBottomConstraints = mainView.bottomToSuperview()
  }
}

//MARK : Notification
extension HSLoginViewController{
  private func setupNotification(){
    self.tearDownNotification()
    HSNotificationManager.receive(keyboardWillShow: self, selector: #selector(keyboardWilShow(_:)))
    HSNotificationManager.receive(keyboardWillHide: self, selector: #selector(keyboardWillHide(_:)))
  }
  
  private func tearDownNotification(){
    HSNotificationManager.remove(self)
  }
  
  @objc func keyboardWilShow(_ notification : Notification){
    guard let frame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
      let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
      let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt,
      let mainViewBottomConstraints = self.mainViewBottomConstraints else { return }
    
    let h = frame.height - self.view.safeAreaInsets.bottom
    mainViewBottomConstraints.constant = -h
    
    UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve), animations: {
      self.view.layoutIfNeeded()
    })
  }
  
  @objc func keyboardWillHide(_ notification: Notification){
    guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
      let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt,
      let mainViewBottomConstraints = self.mainViewBottomConstraints else { return }
    
    let h:CGFloat = 0
    mainViewBottomConstraints.constant = h
    
    UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve), animations: {
      self.view.layoutIfNeeded()
    })
  }
}

//MARk:Admin Login
extension HSLoginViewController:HSLoginViewDelegate{
  func doubleFingerDoubleTapped() {
    self.showAdminLoginAlert()
  }
  
  private func showAdminLoginAlert(){
    let alert = UIAlertController(title: "Admin Login", message: "Enter Username and Password", preferredStyle: .alert)
    //OK Action
    let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
      guard let textFields = alert.textFields,
        !textFields.isEmpty
        else {return}
      
      let loginParams = textFields.map{$0.text}
      
      self.adminLoginToRegisterPage(loginParams: loginParams)
    }
    
    //Cancel Action
    let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
    
    //TextFields
    alert.addTextField { (adminTextField) in
      adminTextField.placeholder = LOCALIZE("Username")
    }
    alert.addTextField { (passwordTextField) in
      passwordTextField.placeholder = LOCALIZE("Password")
      passwordTextField.isSecureTextEntry = true
    }
    
    alert.addAction(okAction)
    alert.addAction(cancelAction)
    
    //Present
    self.present(alert, animated: true, completion: nil)
  }
  
  private func adminLoginToRegisterPage(loginParams:[String?]){
    guard let username = loginParams.first as? String,
          let password = loginParams.last as? String,
          username == LOGIN_USERNAME,
          password == LOGIN_PASSWORD
      else {return}
    let registerVC = HSRegisterViewController()
    self.present(registerVC, animated: true, completion: nil)
  }
}

//MARK: Button Delegate
extension HSLoginViewController:HSButtonViewDelegate{
  func buttonViewTapped(view: HSButtonView) {
    if view == mainView?.loginBtn{
      //Hide Keyboard
      mainView?.emailField?.resignFirstResponder()
      mainView?.passwordField?.resignFirstResponder()
      
      guard let email = mainView?.emailField?.text,email.count > 0 else {
        self.createDropDownAlert(message: "Enter Email", type: .error)
        return
      }
      
      guard let password = mainView?.passwordField?.text,password.count > 0 else {
        self.createDropDownAlert(message: "Enter Password", type: .error)
        return
      }
      
      self.userlogin(email: email, password: password)
    }
  }
}

//MARk:Login Function
extension HSLoginViewController:HSUserLogin{
  private func userlogin(email:String,password:String){
    HSActivityIndicator.shared.start(view: self.view)
    self.loginWithEmail(email: email, password: password) { (error) in
      if let error = error{
        self.createDropDownAlert(message: error.localizedDescription, type: .error)
        HSActivityIndicator.shared.stop()
        return
      }
      HSActivityIndicator.shared.stop()
      self.dismiss(animated: true, completion: nil)
    }
  }
  
  private func createDropDownAlert(message:String,type:HSDropDownType){
    let dropDown = HSDropDownNotification()
    dropDown.text = LOCALIZE(message)
    dropDown.type = type
    appDelegate.window?.addSubview(dropDown)
  }
  
}
