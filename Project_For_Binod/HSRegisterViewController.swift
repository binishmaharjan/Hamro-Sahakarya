//
//  HSRegisterViewController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/03/24.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import TinyConstraints

class HSRegisterViewController:HSViewController{
  //MARK:Elements
  private weak var mainView:HSRegisterView?
  private var mainViewBottomConstraints:Constraint?
  
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
  
  //MARK:Setup
  private func setup(){
    let mainView = HSRegisterView()
    self.mainView = mainView
    mainView.delegate = self
    self.view.addSubview(mainView)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.setupNotification()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.tearDownNotification()
  }
  
  private func setupConstraints(){
    guard  let mainView = self.mainView
      else {return}
    mainView.edgesToSuperview(excluding: .bottom,usingSafeArea:true)
    mainViewBottomConstraints = mainView.bottomToSuperview()
  }
}

//MARK:Notification
extension HSRegisterViewController{
  
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

//MARK:Status & Color Field
extension HSRegisterViewController:HSRegisterViewDelegate{
  func statusFieldWasPressed() {
    self.showStatusSelectionMenu()
  }
  
  private func showStatusSelectionMenu(){
    let alertController = UIAlertController(title: "Status Selection", message: "Select From Below", preferredStyle: .actionSheet)
    //MemberAction
    let memberAction = UIAlertAction(title: HSUserType.member.rawValue, style: .default) { (_) in
      self.statusItemWasSelected(status: HSUserType.member)
    }
    
    //Admin Action
    let adminAction = UIAlertAction(title: HSUserType.admin.rawValue, style: .default) { (_) in
      self.statusItemWasSelected(status: HSUserType.admin)
    }
    
    //Cancel Action
    let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
    
    alertController.addAction(memberAction)
    alertController.addAction(adminAction)
    alertController.addAction(cancelAction)
    self.present(alertController, animated: true, completion: nil)
  }
  
  private func statusItemWasSelected(status:HSUserType){
    guard let mainView = self.mainView else {return}
    mainView.userStatus = status
  }
  
  func colorFieldWasPressed() {
    self.showColorPicker()
  }
  
  private func showColorPicker(){
    let colorAlert = UIAlertController(style: .actionSheet)
    colorAlert.addColorPicker { (color) in
      let hexString = color.toHex
      self.colorWasPicked(hexString: hexString)
    }
    colorAlert.addAction(UIAlertAction(title: "Done", style: .destructive, handler: nil))
    self.present(colorAlert, animated: true, completion: nil)
  }
  
  private func colorWasPicked(hexString:String?){
    guard let mainView = self.mainView,
          let hexString = hexString
    else {return}
    mainView.userColorHex = hexString
  }
}

//MARK:Button Delegate
extension HSRegisterViewController:HSButtonViewDelegate{
  func buttonViewTapped(view: HSButtonView) {
    if view == mainView?.backBtn{
      self.dismiss(animated: true, completion: nil)
    }
    
    if view == mainView?.registerBtn{
      self.validateFieldsForRegisteringUser()
    }
  }
}

//MARK:RegisterUser
extension HSRegisterViewController:HSRegisterUser,HSUserDatabase,HSGroupLogManager{
  private func validateFieldsForRegisteringUser(){

    guard let email = mainView?.emailField?.text, email.count > 0 else {
      createDropDownAlert(message: "Enter Email",type: .error)
      return
    }
    
    guard let username = mainView?.usernameField?.text, username.count > 0 else {
      createDropDownAlert(message: "Enter Fullname",type: .error)
      return
    }
    
    guard let password = mainView?.passwordField?.text, password.count > 0 else {
      createDropDownAlert(message: "Enter Password", type: .error)
      return
    }
    
    guard let initialAmountString = mainView?.initialAmountField?.text,
              initialAmountString.count > 0,
          let initialAmount = Int(initialAmountString) else{
      createDropDownAlert(message: "Enter Initial Amount", type: .error)
      return
    }
    
    guard let memeber = mainView?.userStatus else{
      return
    }
    
    guard let colorHex = mainView?.userColorHex else {
      return
    }
    
    //Register user
    HSActivityIndicator.shared.start(view: self.view)
    self.resgisterEmailUser(email: email, password: password, username: username, initialAmount: initialAmount, status: memeber.rawValue, colorHex: colorHex) { (userId, error) in
      if let error = error{
        HSActivityIndicator.shared.stop()
        self.createDropDownAlert(message: error.localizedDescription, type: .error)
        return
      }

      guard let userId = userId else{
        HSActivityIndicator.shared.stop()
        self.createDropDownAlert(message: "No User Id", type: .error)
        return
      }
      
      //Write info to the database
      self.writeUserInfoToFireStore(uid: userId, email: email, username: username, initialAmount: initialAmount, keyword: password, status: memeber.rawValue, colorHex: colorHex, completion: { (error) in
        
        if let error = error{
          HSActivityIndicator.shared.stop()
          self.createDropDownAlert(message: error.localizedDescription, type: .error)
          return
        }
        
        //Write Log
        self.writeLog(logOwner: userId, logCreator: HAMRO_SAHAKARYA, amount: initialAmount, logType: HSLogType.joined.rawValue, dateCreated: HSDate.dateToString(), completion: { (error) in
          if let error = error{
            HSActivityIndicator.shared.stop()
            self.createDropDownAlert(message: error.localizedDescription, type: .error)
            return
          }
          
          //Successful
          HSActivityIndicator.shared.stop()
          self.createDropDownAlert(message: "Account Created", type: .success)
          self.dismiss(animated: true, completion: nil)
        })

      })
      
    }
  }
  
  private func createDropDownAlert(message:String,type:HSDropDownType){
    let dropDown = HSDropDownNotification()
    dropDown.text = LOCALIZE(message)
    dropDown.type = type
    appDelegate.window?.addSubview(dropDown)
  }
}

