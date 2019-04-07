//
//  HSHomeController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/04/06.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import TinyConstraints


class HSHomeViewController:HSViewController{
  //MARK:Elements
  private weak var header:UIView?
  private weak var titleLbl:UILabel?
  
  weak var topMenu:HSTopMenu?
  weak var homePager:HSHomePagerController?
  
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
    //Header
    let header = UIView()
    self.header = header
    header.backgroundColor = HSColors.white
    self.view.addSubview(header)
    
    let titleLbl = UILabel()
    self.titleLbl = titleLbl
    titleLbl.text = LOCALIZE("Hamro Sahakarya")
    titleLbl.font = HSFont.heavy(size: 14)
    titleLbl.textColor = HSColors.black
    titleLbl.textAlignment = .center
    header.addSubview(titleLbl)
    
    //Top Menu
    let topMenu = HSTopMenu()
    self.topMenu = topMenu
    self.view.addSubview(topMenu)
    
    //Homepager
    let homePager = HSHomePagerController(transitionStyle: .scroll, navigationOrientation: .horizontal,options:nil)
    self.homePager = homePager
    self.view.addSubview(homePager.view)
    self.addChild(homePager)
    
    //Passing the object to each other
    homePager.topMenu = topMenu
    topMenu.homePager = homePager
  }
  
  private func setupConstraints(){
    guard let header = self.header,
      let titleLbl = self.titleLbl,
      let topMenu = self.topMenu,
      let homePager = self.homePager
      else {return}
    header.edgesToSuperview(excluding:.bottom,usingSafeArea:true)
    header.height(44)
    
    titleLbl.centerInSuperview()
    
    topMenu.topToBottom(of: header)
    topMenu.rightToSuperview()
    topMenu.leftToSuperview()
    topMenu.height(44)
    
    homePager.view.topToBottom(of: topMenu)
    homePager.view.edgesToSuperview(excluding:.top,usingSafeArea:true)
  }
}
