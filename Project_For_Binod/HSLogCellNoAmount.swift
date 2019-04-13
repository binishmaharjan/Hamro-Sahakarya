//
//  HSLogCellNoAmount.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/04/13.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import TinyConstraints

class HSLogCellNoAmount:UITableViewCell{
  //MARK:Elements
  private weak var container:UIView?
  private weak var logCreatorLabel:UILabel?
  private weak var logCreatorImage:UIImageView?
  private weak var arrowImage:UIImageView?
  private weak var logOwnerLabel:UILabel?
  private weak var logOwnerImage:UIImageView?
  private weak var descriptionLabel:UILabel?
  private weak var byLabel:UILabel?
  private weak var dateLabel:UILabel?
  
  var log:HSLog?{didSet{self.downloadUsers()}}
  var owner:HSMemeber?{didSet{isLogOwnerDownloaded = !(owner == nil)}}
  var creator:HSMemeber?{didSet{isLogCreatorDownloaded = !(creator == nil)}}
  
  var isLogOwnerDownloaded:Bool = false{didSet{self.executeReloadData()}}
  var isLogCreatorDownloaded:Bool = false{didSet{self.executeReloadData()}}
  
  //MARK:Init
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK:Setup
  private func setup(){
    self.backgroundColor = HSColors.white
    
    //Container
    let container = UIView()
    self.container = container
    container.backgroundColor = HSColors.white
    container.dropShadow(opacity:0.2,offset:CGSize(width: 0, height: 0))
    container.layer.cornerRadius = 5
    self.addSubview(container)
    
    //Log Creator
    let logCreatorLabel = UILabel()
    self.logCreatorLabel = logCreatorLabel
    container.addSubview(logCreatorLabel)
    logCreatorLabel.text = LOCALIZE("Member")
    logCreatorLabel.font = HSFont.bold(size: 14)
    logCreatorLabel.textAlignment = .center
    logCreatorLabel.textColor = HSColors.blue
    logCreatorLabel.adjustsFontSizeToFitWidth = true
    
    let logCreatorImage = UIImageView()
    self.logCreatorImage = logCreatorImage
    container.addSubview(logCreatorImage)
    logCreatorImage.image = UIImage(named: "hamro_sahakarya")
    logCreatorImage.contentMode = .scaleAspectFit
    logCreatorImage.clipsToBounds = true
    logCreatorImage.layer.cornerRadius = 18
    
    //Arrow
    let arrowImage = UIImageView()
    self.arrowImage = arrowImage
    container.addSubview(arrowImage)
    arrowImage.image = UIImage(named: "icon_arrow")
    arrowImage.contentMode = .scaleAspectFit
    
    //Log Owner
    let logOwnerLabel = UILabel()
    self.logOwnerLabel = logOwnerLabel
    container.addSubview(logOwnerLabel)
    logOwnerLabel.text = LOCALIZE("Member")
    logOwnerLabel.font = HSFont.bold(size: 14)
    logOwnerLabel.textAlignment = .center
    logOwnerLabel.textColor = HSColors.orange
    logOwnerLabel.adjustsFontSizeToFitWidth = true
    
    let logOwnerImage = UIImageView()
    self.logOwnerImage = logOwnerImage
    container.addSubview(logOwnerImage)
    logOwnerImage.image = UIImage(named: "hamro_sahakarya")
    logOwnerImage.contentMode = .scaleAspectFit
    logOwnerImage.clipsToBounds = true
    logOwnerImage.layer.cornerRadius = 18
    
    //Description
    let descriptionLabel = UILabel()
    self.descriptionLabel = descriptionLabel
    container.addSubview(descriptionLabel)
    descriptionLabel.text = LOCALIZE("Description")
    descriptionLabel.font = HSFont.bold(size: 14)
    descriptionLabel.textColor = HSColors.black
    descriptionLabel.numberOfLines = 0
    
    //By
    let byLabel = UILabel()
    self.byLabel = byLabel
    container.addSubview(byLabel)
    byLabel.textColor = HSColors.black
    byLabel.text = LOCALIZE("By:")
    byLabel.font = HSFont.normal(size: 14)
    
    //Date
    let dateLabel = UILabel()
    self.dateLabel = dateLabel
    container.addSubview(dateLabel)
    dateLabel.text = LOCALIZE("1999/01/01 12:00:00")
    dateLabel.textColor = HSColors.orange
    dateLabel.font = HSFont.bold(size: 10)
  }
  
  private func setupConstraints(){
    guard let container = self.container,
      let logOwnerLabel = self.logOwnerLabel,
      let logOwnerImage = self.logOwnerImage,
      let arrowImage = self.arrowImage,
      let logCreatorLabel = self.logCreatorLabel,
      let logCreatorImage = self.logCreatorImage,
      let descriptionLabel = self.descriptionLabel,
      let byLabel = self.byLabel,
      let dateLabel = self.dateLabel
      else {return}
    
    container.edgesToSuperview(insets: UIEdgeInsets(top: Constants.CONTAINER_VER_MARGIN,
                                                    left: Constants.CONTAINER_HOR_MARGIN,
                                                    bottom: Constants.CONTAINER_VER_MARGIN,
                                                    right: Constants.CONTAINER_HOR_MARGIN))
    
    arrowImage.topToSuperview(offset:Constants.ARRROW_TOP_MARGIN)
    arrowImage.width(Constants.ARROW_SIZE)
    arrowImage.height(to: arrowImage,arrowImage.widthAnchor)
    arrowImage.centerXToSuperview()
    
    logOwnerImage.rightToLeft(of: arrowImage,offset: -Constants.ICON_HOR_MARGIN)
    logOwnerImage.centerY(to: arrowImage)
    logOwnerImage.width(Constants.ICON_SIZE)
    logOwnerImage.height(to:logOwnerImage,logOwnerImage.widthAnchor)
    
    
    logOwnerLabel.centerY(to: arrowImage)
    logOwnerLabel.leftToSuperview()
    logOwnerLabel.rightToLeft(of: logOwnerImage)
    
    logCreatorImage.leftToRight(of: arrowImage,offset: Constants.ICON_HOR_MARGIN)
    logCreatorImage.centerY(to: arrowImage)
    logCreatorImage.width(Constants.ICON_SIZE)
    logCreatorImage.height(to:logCreatorImage,logCreatorImage.widthAnchor)
    
    logCreatorLabel.centerY(to: arrowImage)
    logCreatorLabel.rightToSuperview()
    logCreatorLabel.leftToRight(of: logCreatorImage)
    
    descriptionLabel.topToBottom(of: logOwnerImage,offset: Constants.DESCRIPTION_TOP_MARGIN)
    descriptionLabel.leftToSuperview(offset:Constants.DESCRIPTION_HOR_MARGIN)
    descriptionLabel.rightToSuperview(offset:-Constants.DESCRIPTION_HOR_MARGIN)
    
    byLabel.topToBottom(of: descriptionLabel,offset: Constants.BY_LABEL_TOP_MARGIN)
    byLabel.left(to: descriptionLabel)
    byLabel.right(to: descriptionLabel)
    
    dateLabel.rightToSuperview(offset:-Constants.DATE_LABEL_RIGHT_MARGIN)
    dateLabel.topToBottom(of: byLabel,offset: Constants.DATE_LABEL_TOP_MARGIN)
    
    container.bottom(to: dateLabel,offset:Constants.CONTAINER_BOTTOM_MARGIN)
  }
}

extension HSLogCellNoAmount:HSUserDatabase{
  private func downloadUsers(){
    guard let log = self.log,
      let logOwner = log.logOwner,
      let logCreator = log.logCreator
      else {return}
    
    //LOG OWNER
    if logOwner == HAMRO_SAHAKARYA{
      let member = HSMemeber.init(uid: HAMRO_SAHAKARYA, username: "Group", email: "", status: "", colorHex: "", iconUrl: "", dateCreated: "", keyword: "", loanTaken: 0, balance: 0, dateUpdated: "")
      self.owner = member
    }else{
      self.downloadUserData(uid: logOwner) { (user, error) in
        if let error = error{
          Dlog(error.localizedDescription)
          return
        }
        self.owner = user
      }
    }
    
    //LOG_CREATOR
    if logCreator == HAMRO_SAHAKARYA{
      let member = HSMemeber.init(uid: HAMRO_SAHAKARYA, username: "Group", email: "", status: "", colorHex: "", iconUrl: "", dateCreated: "", keyword: "", loanTaken: 0, balance: 0, dateUpdated: "")
      self.creator = member
    }else{
      self.downloadUserData(uid: logCreator) { (user, error) in
        if let error = error{
          Dlog(error.localizedDescription)
          return
        }
        self.creator = user
      }
    }
  }
  
  private func shouldReloadData()->Bool{
    return isLogOwnerDownloaded && isLogCreatorDownloaded
  }
  
  private func executeReloadData(){
    if shouldReloadData(){
      self.reloadData()
    }
  }
  
  private func reloadData(){
    guard let log = self.log,
      let owner = self.owner,
      let creator = self.creator
      else {return}
    
    logOwnerLabel?.text = getFirstName(username: owner.username ?? "")
    logCreatorLabel?.text = getFirstName(username: creator.username ?? "")
    byLabel?.text = "-> Supervised By: \(creator.username!)"
    descriptionLabel?.text = getDescriptionText()
    dateLabel?.text = log.dateCreated
  }
  
  private func getDescriptionText()->String{
    guard let log = self.log,
      let logType = log.logType,
      let owner = self.owner
      else {return ""}
    
    switch logType {
    case HSLogType.madeAdmin.rawValue:
      return "\(owner.username ?? "") has been MADE admin."
    case HSLogType.removedAdmin.rawValue:
      return "\(owner.username ?? "") has been REMOVED from admin."
    default:
      return ""
    }
  }
  
  private func getFirstName(username:String)->String{
    return username.components(separatedBy: " ").first ?? username
  }
}

//MARK:Constants
extension HSLogCellNoAmount{
  fileprivate class Constants{
    static let CONTAINER_VER_MARGIN:CGFloat = 5
    static let CONTAINER_HOR_MARGIN:CGFloat = 10
    static let CONTAINER_BOTTOM_MARGIN:CGFloat = 5
    static let ARRROW_TOP_MARGIN:CGFloat = 14
    static let ARROW_SIZE:CGFloat = 15
    static let ICON_HOR_MARGIN:CGFloat = 5
    static let ICON_SIZE:CGFloat = 36
    static let DESCRIPTION_TOP_MARGIN:CGFloat = 5
    static let DESCRIPTION_HOR_MARGIN:CGFloat = 10
    static let BY_LABEL_TOP_MARGIN:CGFloat = 5
    static let DATE_LABEL_RIGHT_MARGIN:CGFloat = 10
    static let DATE_LABEL_TOP_MARGIN:CGFloat = 2
  }
}
