//
//  HSSettingController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/04/14.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import TinyConstraints

class HSSettingController:HSViewController{
  //MARK:Elements
  private weak var mainView:HSSettingView?
  
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
    self.mainView = mainView
    mainView.delegate = self
    self.view.addSubview(mainView)
  }
  
  private func setupConstraints(){
    guard let mainView = self.mainView else {return}
    mainView.edgesToSuperview(usingSafeArea:true)
  }
}

//MARK:Button Delegate
extension HSSettingController:HSButtonViewDelegate{
  func buttonViewTapped(view: HSButtonView) {
    if view == mainView?.backIcon{
      self.navigationController?.popViewController(animated: true)
    }
  }
}
