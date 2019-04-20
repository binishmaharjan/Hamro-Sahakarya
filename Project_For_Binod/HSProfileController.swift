//
//  HSProfileController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/04/08.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import TinyConstraints

class HSProfileController:HSViewController{
  //MARK:Elements
  private weak var mainView:HSProfileView?
  
  //MARK:Init
  override func didInit() {
    super.didInit()
    self.outsideSafeAreaTopViewTemp?.backgroundColor = HSColors.white
    self.outsideSafeAreaBottomViewTemp?.backgroundColor = HSColors.white
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setup()
    self.setupConstraints()
    self.setupNotification()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.isHidden = true
  }
  
  //MARK:Setup
  private func setup(){
    let mainView = HSProfileView()
    self.mainView = mainView
    mainView.settingIconTapped = self.settingIconPressed
    mainView.profileImageWasTapped = self.profileImageWasPressed
    self.view.addSubview(mainView)
  }
  
  private func setupConstraints(){
    guard let mainView = self.mainView else {return}
    mainView.edgesToSuperview(usingSafeArea:true)
  }
}

//MARK:Notification
extension HSProfileController{
  private func setupNotification(){
    self.tearDownNotifiation()
    HSNotificationManager.receive(currentUserInfoDownloaded: self, selector: #selector(receiveSessionUserDownloaded(_:)))
  }
  
  private func tearDownNotifiation(){
    HSNotificationManager.remove(self)
  }
  
  @objc func receiveSessionUserDownloaded(_ notification:Notification){
    guard let mainView = self.mainView else {return}
    mainView.user = HSSessionManager.shared.user
  }
}

//Closure
extension HSProfileController{
  private func settingIconPressed(){
    let settingVC = HSSettingController()
    self.navigationController?.pushViewController(settingVC, animated: true)
  }
  
  private func profileImageWasPressed(image:UIImage?){
    guard let image = image else {return}
    let vc = HSImageDetailController()
    vc.image = image
    self.present(vc, animated: true, completion: nil)
  }
}
