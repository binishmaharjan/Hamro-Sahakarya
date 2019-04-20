//
//  HSProfileView.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/04/08.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import TinyConstraints
import FirebaseFirestore

class HSProfileView:HSBaseView{
  //Elements
  private var header:UIView?
  private var titleLabel:UILabel?
  private var settingIconBG:UIView?
  private var settingIcon:HSImageButtonView?
  private var tableView:UITableView?
  
  //Closure
  var settingIconTapped:(()->())?
  
  var user:HSMemeber?{
    didSet{
      titleLabel?.text = user?.username
      self.tableView?.reloadData()
      self.loadUserLogs()
    }
  }
  
  var logs:[HSLog] = [HSLog]()
  
  private var lastSnapshot : QueryDocumentSnapshot?
  private var isLastPage : Bool = false
  private var isLoading: Bool = false
  private var LAST_COUNT : Int = 4
  
  typealias CELL1 = HSProfileCell
  let CELL1_CLASS = CELL1.self
  let CELL1_ID = NSStringFromClass(CELL1.self)
  
  typealias CELL2 = HSTitleCell
  let CELL2_CLASS = CELL2.self
  let CELL2_ID = NSStringFromClass(CELL2.self)
  
  typealias CELL3 = HSLogCellAmount
  let CELL3_CLASS = CELL3.self
  let CELL3_ID = NSStringFromClass(CELL3.self)
  
  typealias CELL4 = HSLogCellNoAmount
  let CELL4_CLASS = CELL4.self
  let CELL4_ID = NSStringFromClass(CELL4.self)
  
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
    settingIcon.delegate = self
    settingIcon.buttonMargin = .zero
    
    //TableView
    let tableView = UITableView()
    self.tableView = tableView
    self.addSubview(tableView)
    tableView.register(CELL1_CLASS, forCellReuseIdentifier: CELL1_ID)
    tableView.register(CELL2_CLASS, forCellReuseIdentifier: CELL2_ID)
    tableView.register(CELL3_CLASS, forCellReuseIdentifier: CELL3_ID)
    tableView.register(CELL4_CLASS, forCellReuseIdentifier: CELL4_ID)
    tableView.separatorStyle = .none
    tableView.estimatedRowHeight = 100
    tableView.rowHeight = UITableView.automaticDimension
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    tableView.dataSource = self
    tableView.delegate = self
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
extension HSProfileView:UITableViewDataSource,UITableViewDelegate{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2 + logs.count
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
    
    if indexPath.row >= 2{
      let log = logs[indexPath.row - 2]
      if log.logType != HSLogType.madeAdmin.rawValue || log.logType != HSLogType.removedAdmin.rawValue,
          let cell = tableView.dequeueReusableCell(withIdentifier: CELL3_ID, for: indexPath) as? CELL3{
        cell.selectionStyle = .none
        cell.log = log
        return cell
      }
      else if let cell = tableView.dequeueReusableCell(withIdentifier: CELL4_ID, for: indexPath) as? CELL4{
        cell.selectionStyle = .none
        cell.log = log
        return cell
      }
    }
    
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
    let startLoadingIndex = self.logs.count - LAST_COUNT
    if !isLoading,indexPath.row >= startLoadingIndex{
      self.loadMoreUserLogs()
    }
  }
}


//MARK:Downoad User Log
extension HSProfileView:HSGroupLogManager{
  private func loadUserLogs(){
    guard let user = user else {return}
    self.isLoading = true
    self.readUserLog(uid: user.uid) { (logs, lastSnapshot, isLastPage, error) in
      if let error = error{
        Dlog(error.localizedDescription)
        self.isLoading = false
        return
      }
      
      guard let isLastPage = isLastPage,
            let lastSnapshot = lastSnapshot,
            let logs = logs,
            !isLastPage
      else {
        Dlog("This is Last Page")
        self.isLoading = false
        self.isLastPage = true
        return
      }
      
      self.lastSnapshot = lastSnapshot
      self.isLastPage = isLastPage
      self.isLoading = false
      self.logs = logs
      self.tableView?.reloadData()
      
    }
  }
  
  private func loadMoreUserLogs(){
    guard !isLastPage else {Dlog("last Page"); return}
    guard !isLoading else {Dlog("Still Loading"); return }
    guard let user = user else {return}
    
    guard let lastSnapshot = lastSnapshot else {
      Dlog("No Last Snapshot")
      return
    }
    self.isLoading = true
    
    self.readUserLogFromLastSnapshot(uid: user.uid, lastSnapshot: lastSnapshot) { (logs, lastSnapshot, isLastPage, error) in
      if let error = error{
        Dlog(error.localizedDescription)
        self.isLoading = false
        return
      }
      
      guard let isLastPage = isLastPage,
        let lastSnapshot = lastSnapshot,
        let logs = logs,
        !isLastPage
        else {
          Dlog("This is Last Page From More")
          self.isLoading = false
          self.isLastPage = true
          return
      }
      
      self.lastSnapshot = lastSnapshot
      self.isLastPage = isLastPage
      self.isLoading = false
      logs.forEach({ (log) in
        self.logs.append(log)
      })
      self.tableView?.reloadData()
    }
  }
}

//MARK:Setting
extension HSProfileView : HSButtonViewDelegate{
  func buttonViewTapped(view: HSButtonView) {
    if view == settingIcon{
       self.settingIconTapped?()
    }
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
