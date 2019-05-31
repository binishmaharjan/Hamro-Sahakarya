//
//  HSSettingController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/04/14.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import TinyConstraints
import Gallery

class HSSettingController:HSViewController{
  //MARK:Elements
  private weak var settingView:HSSettingView?
  
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
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.isHidden = true
  }
  
  //MARK:Setup
  private func setup(){
    let mainView = HSSettingView()
    self.settingView = mainView
    mainView.delegate = self
    self.view.addSubview(mainView)
  }
  
  private func setupConstraints(){
    guard let mainView = self.settingView else {return}
    mainView.edgesToSuperview(usingSafeArea:true)
  }
}

//MARK:Button Delegate
extension HSSettingController:HSButtonViewDelegate{
  func buttonViewTapped(view: HSButtonView) {
    if view == settingView?.backIcon {
      self.navigationController?.popViewController(animated: true)
    }
  }
}

//MARK:Setting View Delegate
extension HSSettingController:HSSettingDelegate{
  func changeProfilePicturePressed() {
    self.presentImagePicker()
  }
  
  func changePasswordPressed() {
    let changePasswordViewController = ChangePasswordViewController()
    self.navigationController?.pushViewController(changePasswordViewController, animated: true)
  }
  
  func requestForLoanPressed() {
    Dlog("request for loan Pressed")
  }
  
  func termsAndConditionPressed() {
    Dlog("terms and condition Pressed")
  }
  
  func privacyPolicyPressed() {
    Dlog("privacy policy Pressed")
  }
  
  func logoutPressed() {
    HSSessionManager.shared.logout()
  }
  
  func addAmountPressed() {
    Dlog("add amount Pressed")
  }
  
  func addMonthlyFeePressed() {
    Dlog("add monthly fee Pressed")
  }
  
  func loanMemberPressed() {
    Dlog("Loan A Member Pressed")
  }
  
  func loanReturnedPressed() {
    Dlog("laon returned Pressed")
  }
  
  func addExpensePressed() {
    Dlog("add expenses Pressed")
  }
  
  func addExtraPressed() {
    Dlog("add extra Pressed")
  }
  
  func deleteUserPressed() {
    Dlog("deleter user Pressed")
  }
  
  func makeAdminPressed() {
    Dlog("make admin Pressed")
  }
  
  func removeAdminPressed() {
    Dlog("remove admin Pressed")
  }
}

//MARK:Image Picker And Gallery Delegate
extension HSSettingController:GalleryControllerDelegate,HSStorage,HSUserDatabase{
  private func presentImagePicker(){
    let gallery = GalleryController()
    gallery.delegate = self
    Config.tabsToShow = [.imageTab]
    Config.Camera.imageLimit = 1
    present(gallery, animated: true, completion: nil)
  }
  
  func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
    images[0].resolve(completion: { (image) in
      guard let image = image else {return}
      self.saveImageAndUpdateFirestore(image: image)
    })
    controller.dismiss(animated: true, completion: nil)
  }
  
  func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
    
  }
  
  func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
    
  }
  
  func galleryControllerDidCancel(_ controller: GalleryController) {
    Dlog("picker was cancelled")
    controller.dismiss(animated: true, completion: nil)
  }
  
  
  private func saveImageAndUpdateFirestore(image:UIImage){
    HSActivityIndicator.shared.start(view: self.view)
    self.saveImageToStorage(image: image) { (imageUrl, error) in
      if let error = error{
        createDropDownAlert(message: error.localizedDescription, type: .error)
        HSActivityIndicator.shared.stop()
        return
      }
      
      guard let imageUrl = imageUrl else {
        createDropDownAlert(message: EMPTY_DATA_ERROR.localizedDescription, type: .error)
        HSActivityIndicator.shared.stop()
        return
      }
      
      self.updateProfileURL(url: imageUrl, completion: { (error) in
        if let error = error{
          createDropDownAlert(message: error.localizedDescription, type: .error)
          HSActivityIndicator.shared.stop()
          return
        }
        
        createDropDownAlert(message: "Updated", type: .success)
        HSActivityIndicator.shared.stop()
      })
      
    }
  }
}


