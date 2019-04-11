//
//  HSProfileView.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/04/08.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import TinyConstraints

class HSProfileView:HSBaseView{
  //Elements
  private var header:UIView?
  private var titleLabel:UILabel?
  private var settingIconBG:UIView?
  private var settingIcon:HSImageButtonView?
  private var tableView:UITableView?
  
  var user:HSMemeber?{
    didSet{
      titleLabel?.text = user?.username
      self.tableView?.reloadData()
    }
  }
  
  typealias CELL1 = HSProfileCell
  let CELL1_CLASS = CELL1.self
  let CELL1_ID = NSStringFromClass(CELL1.self)
  
  typealias CELL2 = HSTitleCell
  let CELL2_CLASS = CELL2.self
  let CELL2_ID = NSStringFromClass(CELL2.self)
  
  typealias CELL3 = HSLogCellAmount
  let CELL3_CLASS = CELL3.self
  let CELL3_ID = NSStringFromClass(CELL3.self)
  
  //MARK:Init
  override func didInit() {
    super.didInit()
    self.setup()
    self.setupConstraints()
  }
  
  //MARK:Setup
  private func setup(){
    //Header
    let header = UIView()
    self.header = header
    header.backgroundColor = backgroundColor
    self.addSubview(header)
    
    let titleLabel = UILabel()
    self.titleLabel = titleLabel
    header.addSubview(titleLabel)
    titleLabel.text = LOCALIZE("Member")
    titleLabel.font = HSFont.heavy(size: 14)
    titleLabel.textColor = HSColors.black
    titleLabel.textAlignment = .center
    
    let settingIconBG = UIView()
    self.settingIconBG = settingIconBG
    header.addSubview(settingIconBG)
    
    let settingIcon = HSImageButtonView()
    self.settingIcon = settingIcon
    settingIconBG.addSubview(settingIcon)
    settingIcon.image = UIImage(named: "icon_setting")
    settingIcon.buttonMargin = .zero
    
    //TableView
    let tableView = UITableView()
    self.tableView = tableView
    self.addSubview(tableView)
    tableView.register(CELL1_CLASS, forCellReuseIdentifier: CELL1_ID)
    tableView.register(CELL2_CLASS, forCellReuseIdentifier: CELL2_ID)
    tableView.register(CELL3_CLASS, forCellReuseIdentifier: CELL3_ID)
    tableView.separatorStyle = .none
    tableView.estimatedRowHeight = 100
    tableView.rowHeight = UITableView.automaticDimension
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    tableView.dataSource = self
  }
  
  private func setupConstraints(){
    guard let header = self.header,
          let titleLabel = self.titleLabel,
          let settingIconBG = self.settingIconBG,
          let settingIcon = self.settingIcon,
          let tableView = self.tableView
      else {return}
    
    header.edgesToSuperview(excluding:.bottom)
    header.height(Constants.HEADER_HEIGHT)
    
    titleLabel.centerInSuperview()
    
    settingIconBG.rightToSuperview(offset:-Constants.SETTING_ICON_RIGHT_MARGIN)
    settingIconBG.centerYToSuperview()
    settingIconBG.height(Constants.SETTING_ICON_SIZE)
    settingIconBG.width(to: settingIcon,settingIcon.heightAnchor)
    
    settingIcon.edgesToSuperview()
    
    tableView.edgesToSuperview(excluding:.top)
    tableView.topToBottom(of: header)
  }
}


//MARK:TableView Datasource
extension HSProfileView:UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2 + 5
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == 0, let cell = tableView.dequeueReusableCell(withIdentifier: CELL1_ID, for: indexPath) as? CELL1{
      cell.selectionStyle = .none
      cell.user = self.user
      return cell
    }
    
    if indexPath.row == 1, let cell = tableView.dequeueReusableCell(withIdentifier: CELL2_ID, for: indexPath) as? CELL2{
      cell.selectionStyle = .none
      cell.labelText = "MY ACTIVITY"
      return cell
    }
    
    if let cell = tableView.dequeueReusableCell(withIdentifier: CELL3_ID, for: indexPath) as? CELL3{
      cell.selectionStyle = .none
      return cell
    }
    return UITableViewCell()
  }
}

//MARK:Constants
extension HSProfileView{
  fileprivate class Constants{
    static let HEADER_HEIGHT:CGFloat = 44
    static let SETTING_ICON_SIZE:CGFloat = 35
    static let SETTING_ICON_RIGHT_MARGIN:CGFloat = 12
  }
}
