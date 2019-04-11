//
//  HSLogCell.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/04/08.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import TinyConstraints

class HSLogCellAmount:UITableViewCell{
  //MARK:Elements
  private weak var container:UIView?
  private weak var logCreatorLabel:UILabel?
  private weak var logCreatorImage:UIImageView?
  private weak var arrowImage:UIImageView?
  private weak var logOwnerLabel:UILabel?
  private weak var logOwnerImage:UIImageView?
  private weak var descriptionLabel:UILabel?
  private weak var byLabel:UILabel?
  private weak var amountLabel:UILabel?
  private weak var dateLabel:UILabel?
  
  //MARK:Init
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.setup()
    self.setupConstraints()
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
    
    //Amount
    let amountLabel = UILabel()
    self.amountLabel = amountLabel
    container.addSubview(amountLabel)
    amountLabel.text = LOCALIZE("Amount:")
    amountLabel.textColor = HSColors.black
    amountLabel.font = HSFont.normal(size: 14)
    
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
          let amountLabel = self.amountLabel,
          let dateLabel = self.dateLabel
      else {return}
  
    container.edgesToSuperview(insets: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
    
    arrowImage.topToSuperview(offset:14)
    arrowImage.width(15)
    arrowImage.height(to: arrowImage,arrowImage.widthAnchor)
    arrowImage.centerXToSuperview()
    
    logOwnerImage.rightToLeft(of: arrowImage,offset: -5)
    logOwnerImage.centerY(to: arrowImage)
    logOwnerImage.width(36)
    logOwnerImage.height(to:logOwnerImage,logOwnerImage.widthAnchor)
    
    
    logOwnerLabel.centerY(to: arrowImage)
    logOwnerLabel.leftToSuperview()
    logOwnerLabel.rightToLeft(of: logOwnerImage)
    
    logCreatorImage.leftToRight(of: arrowImage,offset: 5)
    logCreatorImage.centerY(to: arrowImage)
    logCreatorImage.width(36)
    logCreatorImage.height(to:logCreatorImage,logCreatorImage.widthAnchor)
    
    logCreatorLabel.centerY(to: arrowImage)
    logCreatorLabel.rightToSuperview()
    logCreatorLabel.leftToRight(of: logCreatorImage)
    
    descriptionLabel.topToBottom(of: logOwnerImage,offset: 5)
    descriptionLabel.leftToSuperview(offset:10)
    descriptionLabel.rightToSuperview(offset:-10)
    
    byLabel.topToBottom(of: descriptionLabel,offset: 5)
    byLabel.left(to: descriptionLabel)
    byLabel.right(to: descriptionLabel)
    
    amountLabel.topToBottom(of: byLabel,offset: 5)
    amountLabel.left(to: descriptionLabel)
    amountLabel.right(to: descriptionLabel)
    
    dateLabel.rightToSuperview(offset:-10)
    dateLabel.topToBottom(of: amountLabel,offset: 2)
    
    container.bottom(to: dateLabel,offset:5)
    
    
  }
}
