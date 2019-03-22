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
    self.view.addSubview(mainView)
  }
  
  private func setupConstraints(){
    guard let mainView = self.mainView
      else {return}
    mainView.edgesToSuperview(excluding: .bottom)
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
