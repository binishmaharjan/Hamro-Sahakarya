//
//  HSLogView.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/04/13.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import TinyConstraints
import FirebaseFirestore

class HSLogView: HSBaseView {
  //MARk:Elements
  private var header:UIView?
  private var titleLabel:UILabel?
  private var tableView:UITableView?
  
  typealias CELL1 = HSLogCellAmount
  let CELL1_CLASS = CELL1.self
  let CELL1_ID = NSStringFromClass(CELL1.self)
  
  typealias CELL2 = HSLogCellNoAmount
  let CELL2_CLASS = CELL2.self
  let CELL2_ID = NSStringFromClass(CELL2.self)
  
  var logs:[HSLog] = [HSLog]()
  
  private var lastSnapshot : QueryDocumentSnapshot?
  private var isLastPage : Bool = false
  private var isLoading: Bool = false
  private var LAST_COUNT : Int = 4
  
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
    titleLabel.text = LOCALIZE("Logs")
    titleLabel.font = HSFont.heavy(size: 14)
    titleLabel.textColor = HSColors.black
    titleLabel.textAlignment = .center
    
    //TableView
    let tableView = UITableView()
    self.tableView = tableView
    self.addSubview(tableView)
    tableView.register(CELL1_CLASS, forCellReuseIdentifier: CELL1_ID)
    tableView.register(CELL2_CLASS, forCellReuseIdentifier: CELL2_ID)
    tableView.separatorStyle = .none
    tableView.estimatedRowHeight = 100
    tableView.rowHeight = UITableView.automaticDimension
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    tableView.dataSource = self
    tableView.delegate = self
    
    self.loadUserLogs()
  }
  
  private func setupConstraints(){
    guard let header = self.header,
          let titleLabel = self.titleLabel,
          let tableView = tableView else {return}
    
    header.edgesToSuperview(excluding:.bottom)
    header.height(Constants.HEADER_HEIGHT)
    
    titleLabel.centerInSuperview()
    
    tableView.edgesToSuperview(excluding:.top)
    tableView.topToBottom(of: header)
  }
}

//MARK:Table View Delegate Datasource
extension HSLogView:UITableViewDelegate,UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return logs.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let log = logs[indexPath.row]
    if log.logType != HSLogType.madeAdmin.rawValue || log.logType != HSLogType.removedAdmin.rawValue,
      let cell = tableView.dequeueReusableCell(withIdentifier: CELL1_ID, for: indexPath) as? CELL1{
      cell.selectionStyle = .none
      cell.log = log
      return cell
    }
    else if let cell = tableView.dequeueReusableCell(withIdentifier: CELL2_ID, for: indexPath) as? CELL2{
      cell.selectionStyle = .none
      cell.log = log
      return cell
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

//MARK:Data
extension HSLogView:HSGroupLogManager{
  private func loadUserLogs(){
    self.isLoading = true
    self.readAllLog() { (logs, lastSnapshot, isLastPage, error) in
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
    
    guard let lastSnapshot = lastSnapshot else {
      Dlog("No Last Snapshot")
      return
    }
    self.isLoading = true
    
    self.readAllLogFromLastSnapshot(lastSnapshot: lastSnapshot) { (logs, lastSnapshot, isLastPage, error) in
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


//MARK:Constant
extension HSLogView{
  fileprivate class Constants{
    static let HEADER_HEIGHT:CGFloat = 44
  }
}
