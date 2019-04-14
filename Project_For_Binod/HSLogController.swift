//
//  HSLogController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/04/13.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import TinyConstraints

class HSLogController:HSViewController{
  //MARK:Elements
  private weak var mainView:HSLogView?
  
  //MARK:Init
  override func didInit() {
    super.didInit()
    self.outsideSafeAreaTopViewTemp?.backgroundColor = HSColors.white
    self.outsideSafeAreaBottomViewTemp?.backgroundColor = HSColors.white
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setup()
    self.setupConstrains()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.isHidden = true
  }
  
  //MARK:Setup
  private func setup(){
    let mainView = HSLogView()
    self.mainView = mainView
    self.view.addSubview(mainView)
  }
  
  private func setupConstrains(){
    guard let mainView = mainView else {return}
    mainView.edgesToSuperview(usingSafeArea:true)
  }
}
