//
//  HSProfileCell.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/04/08.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import TinyConstraints


class HSProfileCell:UITableViewCell{
  //MARK:Elements
  private weak var container:UIView?
  private weak var profileImage:UIImageView?
  private weak var usernameLabel:UILabel?
  private weak var emailLabel:UILabel?
  
  var user:HSMemeber?{
    didSet{
      self.relayout()
    }
  }
  
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
    //Container
    let container = UIView()
    self.container = container
    self.addSubview(container)
    
    //Profile Image
    let profileImage = UIImageView()
    self.profileImage = profileImage
    container.addSubview(profileImage)
    profileImage.image = UIImage(named: "hamro_sahakarya")
    profileImage.contentMode = .scaleAspectFit
    profileImage.clipsToBounds = true
    profileImage.layer.cornerRadius = Constants.IMAGE_SIZE / 2
    
    //Username
    let usernameLabel = UILabel()
    self.usernameLabel = usernameLabel
    container.addSubview(usernameLabel)
    usernameLabel.text = LOCALIZE("Member")
    usernameLabel.textColor = HSColors.black
    usernameLabel.textAlignment = .center
    usernameLabel.font = HSFont.bold(size: 14)
    
    //Email
    let emailLabel = UILabel()
    self.emailLabel = emailLabel
    container.addSubview(emailLabel)
    emailLabel.text = LOCALIZE("Email")
    emailLabel.font = HSFont.normal(size: 12)
    emailLabel.textColor = HSColors.black
    emailLabel.textAlignment = .center
  }
  
  private func setupConstraints(){
    guard let profileImage = self.profileImage,
      let usernameLabel = self.usernameLabel,
      let emailLabel = self.emailLabel,
      let container = self.container
      else {return}
    
    container.edgesToSuperview()
    
    profileImage.topToSuperview(offset:Constants.IMAGE_TOP_MARGIN)
    profileImage.centerXToSuperview()
    profileImage.width(Constants.IMAGE_SIZE)
    profileImage.height(to:profileImage, profileImage.widthAnchor)
    
    usernameLabel.centerXToSuperview()
    usernameLabel.topToBottom(of: profileImage,offset: Constants.USERNAME_TOP_MARGIN)
    
    emailLabel.centerXToSuperview()
    emailLabel.topToBottom(of: usernameLabel,offset: Constants.EMAIL_TOP_MARGIN)
    
    container.bottom(to: emailLabel,offset:Constants.BOTTOM_MARGIN)
  }
  
  private func relayout(){
    guard let profileImage = self.profileImage,
      let usernameLabel = self.usernameLabel,
      let emailLabel = self.emailLabel,
      let user = self.user
      else {return}
    
      usernameLabel.text = user.username
      emailLabel.text = user.email
  }
}

//MARK:Constants
extension HSProfileCell{
  fileprivate class Constants{
    static let IMAGE_TOP_MARGIN:CGFloat = 18
    static let IMAGE_SIZE:CGFloat = 100
    static let USERNAME_TOP_MARGIN:CGFloat = 10
    static let EMAIL_TOP_MARGIN:CGFloat = 5
    static let BOTTOM_MARGIN:CGFloat = 15
  }
}
