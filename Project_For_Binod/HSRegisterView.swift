//
//  HSRegisterView.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/03/24.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import TinyConstraints

protocol HSRegisterViewDelegate:NSObjectProtocol{
  func statusFieldWasPressed()
  func colorFieldWasPressed()
}

class HSRegisterView:HSBaseView{
  //MARK :Elements
  private weak var header:UIView?
  private weak var titleLbl:UILabel?
  weak var backBtn:HSImageButtonView?
  
  private weak var scrollView:UIScrollView?
  private weak var contentView:UIView?
  private var contentViewHeightConstraints:Constraint?
  
  private weak var pageTitle:UILabel?
  
  private weak var emailLabel:UILabel?
  private weak var emailBG:UIView?
  private weak var emailField:UITextField?
  
  private weak var passwordLabel:UILabel?
  private weak var passwordBG:UIView?
  private weak var passwordField:UITextField?
  
  private weak var statusLabel:UILabel?
  private weak var statusBG:UIView?
  private weak var statusField:UILabel?
  
  private weak var colorLabel:UILabel?
  private weak var colorBG:UIView?
  
  private weak var registerBtnBG:UIView?
  private weak var registerBtn:HSTextButton?
  
  var delegate:HSRegisterViewDelegate?{
    didSet{
      backBtn?.delegate = delegate as? HSButtonViewDelegate
    }
  }
  var userStatus:HSUserType = HSUserType.member{
    didSet{
      statusField?.text = userStatus.rawValue
    }
  }
  var userColorHex:String = "ffffff"{
    didSet{
      colorBG?.backgroundColor = UIColor(hexString: userColorHex)
    }
  }
  
  //MARK:Initializer
  override func didInit() {
    super.didInit()
    self.setup()
    self.setupConstraints()
  }
  
  //MARK:Setup
  private func setup(){
    //scroll
    let scrollView = UIScrollView()
    self.scrollView = scrollView
    self.addSubview(scrollView)
    
    //contentView
    let contentView = UIView()
    self.contentView = contentView
    scrollView.addSubview(contentView)
    
    //header
    let header = UIView()
    self.header = header
    contentView.addSubview(header)
    
    //backbtn
    let backBtn = HSImageButtonView()
    self.backBtn = backBtn
    backBtn.image = UIImage(named: "icon_close")
    header.addSubview(backBtn)
    
    let pageTitle = UILabel()
    self.pageTitle = pageTitle
    let blackAttrs = [NSAttributedString.Key.foregroundColor : HSColors.black]
    let orangeAttrs = [NSAttributedString.Key.foregroundColor : HSColors.orange]
    let titleText = NSMutableAttributedString(string: LOCALIZE("Register "), attributes: blackAttrs)
    let orangeText = NSMutableAttributedString(string: LOCALIZE("User"), attributes: orangeAttrs)
    titleText.append(orangeText)
    pageTitle.font = HSFont.heavy(size: Constants.TITLE_FONT_SIZE)
    pageTitle.attributedText = titleText
    contentView.addSubview(pageTitle)
    
    //email
    let emailLabel = UILabel()
    self.emailLabel = emailLabel
    emailLabel.text = LOCALIZE("Email")
    emailLabel.font = HSFont.normal(size: Constants.TEXT_FONT_SIZE)
    emailLabel.textColor = HSColors.grey
    contentView.addSubview(emailLabel)
    
    let emailBG = UIView()
    self.emailBG = emailBG
    emailBG.backgroundColor = HSColors.white
    emailBG.layer.borderColor = HSColors.orange.cgColor
    emailBG.layer.borderWidth = Constants.BORDER_WIDTH
    emailBG.layer.cornerRadius = Constants.CORNER_RADIUS
    contentView.addSubview(emailBG)
    
    
    let emailField = UITextField()
    self.emailField = emailField
    emailField.backgroundColor = HSColors.white
    emailField.placeholder = LOCALIZE("Email")
    emailField.font = HSFont.normal(size: Constants.TEXT_FONT_SIZE)
    emailField.textColor = HSColors.black
    emailField.delegate = self
    emailBG.addSubview(emailField)
    
    //password
    let passwordLabel = UILabel()
    self.passwordLabel = passwordLabel
    passwordLabel.text = LOCALIZE("Password")
    passwordLabel.font = HSFont.normal(size: Constants.TEXT_FONT_SIZE)
    passwordLabel.textColor = HSColors.grey
    contentView.addSubview(passwordLabel)
    
    let passwordBG = UIView()
    self.passwordBG = passwordBG
    passwordBG.backgroundColor = HSColors.white
    passwordBG.layer.borderWidth = Constants.BORDER_WIDTH
    passwordBG.layer.borderColor = HSColors.orange.cgColor
    passwordBG.layer.cornerRadius = Constants.CORNER_RADIUS
    contentView.addSubview(passwordBG)
    
    let passwordField = UITextField()
    self.passwordField = passwordField
    passwordField.backgroundColor = HSColors.white
    passwordField.placeholder = LOCALIZE("Password")
    passwordField.font = HSFont.normal(size: Constants.TEXT_FONT_SIZE)
    passwordField.textColor = HSColors.black
    passwordField.delegate = self
    passwordField.isSecureTextEntry = true
    passwordBG.addSubview(passwordField)
    
    //status
    let statusLabel = UILabel()
    self.statusLabel = statusLabel
    statusLabel.text = LOCALIZE("Status")
    statusLabel.font = HSFont.normal(size: Constants.TEXT_FONT_SIZE)
    statusLabel.textColor = HSColors.grey
    contentView.addSubview(statusLabel)
    
    let statusBG = UIView()
    self.statusBG = statusBG
    statusBG.backgroundColor = HSColors.white
    statusBG.layer.borderWidth = Constants.BORDER_WIDTH
    statusBG.layer.borderColor = HSColors.orange.cgColor
    statusBG.layer.cornerRadius = Constants.CORNER_RADIUS
    contentView.addSubview(statusBG)
    
    let statusField = UILabel()
    self.statusField = statusField
    statusField.backgroundColor = HSColors.white
    statusField.text = HSUserType.member.rawValue
    statusField.font = HSFont.bold(size: Constants.TEXT_FONT_SIZE)
    statusField.textColor = HSColors.black
    statusField.isUserInteractionEnabled = true
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(statusFieldWasTapped))
    statusField.addGestureRecognizer(tapGesture)
    statusBG.addSubview(statusField)
    
    //color
    let colorLabel = UILabel()
    self.colorLabel = colorLabel
    colorLabel.text = LOCALIZE("Color")
    colorLabel.font = HSFont.normal(size: Constants.TEXT_FONT_SIZE)
    colorLabel.textColor = HSColors.grey
    contentView.addSubview(colorLabel)
    
    let colorBG = UIView()
    self.colorBG = colorBG
    colorBG.backgroundColor = HSColors.white
    colorBG.layer.borderWidth = Constants.BORDER_WIDTH
    colorBG.layer.borderColor = HSColors.orange.cgColor
    colorBG.layer.cornerRadius = Constants.CORNER_RADIUS
    colorBG.isUserInteractionEnabled = true
    let colorTapGesture = UITapGestureRecognizer(target: self, action: #selector(colorFieldWasPressed))
    colorBG.addGestureRecognizer(colorTapGesture)
    contentView.addSubview(colorBG)
    
    //register btn
    let registerBtnBG = UIView()
    self.registerBtnBG = registerBtnBG
    registerBtnBG.backgroundColor = HSColors.orange
    registerBtnBG.layer.cornerRadius = Constants.CORNER_RADIUS
    contentView.addSubview(registerBtnBG)
    
    let registerBtn = HSTextButton()
    self.registerBtn = registerBtn
    registerBtn.text = LOCALIZE("Register")
    registerBtn.textColor = HSColors.white
    registerBtn.font = HSFont.bold(size: Constants.TEXT_FONT_SIZE)
    registerBtnBG.addSubview(registerBtn)
  }
  
  private func setupConstraints(){
    guard let scrollView = self.scrollView,
          let contentView = self.contentView,
          let header = self.header,
          let backBtn = self.backBtn,
          let pageTitle = self.pageTitle,
          let emailLabel = self.emailLabel,
          let emailBG = self.emailBG,
          let emailField = self.emailField,
          let passwordLabel = self.passwordLabel,
          let passwordBG = self.passwordBG,
          let passwordField = self.passwordField,
          let statusLabel = self.statusLabel,
          let statusBG = self.statusBG,
          let statusField = self.statusField,
          let colorLabel = self.colorLabel,
          let colorBG = self.colorBG,
          let registerBtn = self.registerBtn,
          let registerBtnBG = self.registerBtnBG
    else {return}
    
    scrollView.edgesToSuperview()
    
    contentView.edgesToSuperview()
    contentView.width(to: scrollView)
    
    header.edgesToSuperview(excluding:.bottom)
    header.height(Constants.HEADER_H)
    
    backBtn.centerYToSuperview()
    backBtn.leftToSuperview(offset:Constants.BACK_C_X)
    
    pageTitle.topToSuperview(offset:Constants.TITLE_LABEL_TOP_MARGIN)
    pageTitle.leftToSuperview(offset:Constants.LEFT_MARGIN)
    
    emailLabel.left(to: pageTitle)
    emailLabel.topToBottom(of: pageTitle, offset:Constants.TITLE_LABEL_BOTTOM_MARGIN)
    
    emailBG.topToBottom(of: emailLabel, offset: Constants.TEXT_FIELD_TOP_MARGIN)
    emailBG.leftToSuperview(offset: Constants.LEFT_MARGIN)
    emailBG.rightToSuperview(offset:  -Constants.LEFT_MARGIN)
    emailBG.height(Constants.TEXT_FIELD_HEIGHT)
    
    emailField.edgesToSuperview(insets:UIEdgeInsets(top: Constants.ZERO,
                                                    left: Constants.TEXT_FIELD_HOR_INSETS,
                                                    bottom: Constants.ZERO,
                                                    right: Constants.TEXT_FIELD_HOR_INSETS))
    
    passwordLabel.topToBottom(of: emailBG,offset: Constants.TEXT_FIELD_BOTTOM_MARGIN)
    passwordLabel.left(to: emailLabel)
    
    passwordBG.topToBottom(of: passwordLabel, offset: Constants.TEXT_FIELD_TOP_MARGIN)
    passwordBG.leftToSuperview(offset: Constants.LEFT_MARGIN)
    passwordBG.rightToSuperview(offset:  -Constants.LEFT_MARGIN)
    passwordBG.height(Constants.TEXT_FIELD_HEIGHT)
    
    passwordField.edgesToSuperview(insets:UIEdgeInsets(top: Constants.ZERO,
                                                       left: Constants.TEXT_FIELD_HOR_INSETS,
                                                       bottom: Constants.ZERO,
                                                       right: Constants.TEXT_FIELD_HOR_INSETS))
    
    statusLabel.left(to: emailLabel)
    statusLabel.topToBottom(of: passwordBG,offset: Constants.TEXT_FIELD_BOTTOM_MARGIN)
    
    statusBG.topToBottom(of: statusLabel,offset: Constants.TEXT_FIELD_TOP_MARGIN)
    statusBG.leftToSuperview(offset: Constants.LEFT_MARGIN)
    statusBG.rightToSuperview(offset: -Constants.LEFT_MARGIN)
    statusBG.height(Constants.TEXT_FIELD_HEIGHT)
    
    statusField.edgesToSuperview(insets:UIEdgeInsets(top: Constants.ZERO,
                                                     left: Constants.TEXT_FIELD_HOR_INSETS,
                                                     bottom: Constants.ZERO,
                                                     right: Constants.TEXT_FIELD_HOR_INSETS))
    
    colorLabel.left(to: emailLabel)
    colorLabel.topToBottom(of: statusBG,offset: Constants.TEXT_FIELD_BOTTOM_MARGIN)
    
    colorBG.topToBottom(of: colorLabel,offset: Constants.TEXT_FIELD_TOP_MARGIN)
    colorBG.leftToSuperview(offset: Constants.LEFT_MARGIN)
    colorBG.rightToSuperview(offset: -Constants.LEFT_MARGIN)
    colorBG.height(Constants.TEXT_FIELD_HEIGHT)
    
    registerBtnBG.topToBottom(of: colorBG, offset: Constants.BUTTON_TOP_MARGIN)
    registerBtnBG.left(to: emailBG)
    registerBtnBG.right(to: emailBG)
    registerBtnBG.height(Constants.BUTTON_HEIGHT)
    
    registerBtn.edgesToSuperview()
    
    contentView.bottom(to: registerBtn)
  }
}

//TextField Delegate
extension HSRegisterView:UITextFieldDelegate{
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  @objc private func statusFieldWasTapped(){
    delegate?.statusFieldWasPressed()
  }
  
  @objc private func colorFieldWasPressed(){
    delegate?.colorFieldWasPressed()
  }
}

//Constants
extension HSRegisterView{
  fileprivate class Constants{
    static let HEADER_H:CGFloat = 44
    static let BACK_C_X:CGFloat = 12
    
    static let TITLE_LABEL_TOP_MARGIN:CGFloat = 76
    static let LEFT_MARGIN:CGFloat = 30
    static let TITLE_LABEL_BOTTOM_MARGIN:CGFloat = 66
    static let TEXT_FIELD_TOP_MARGIN:CGFloat = 5
    static let TEXT_FIELD_HEIGHT:CGFloat = 44
    static let TEXT_FIELD_HOR_INSETS:CGFloat = 16
    static let TEXT_FIELD_BOTTOM_MARGIN:CGFloat = 15
    static let BUTTON_TOP_MARGIN:CGFloat = 20
    static let BUTTON_HEIGHT:CGFloat = 44
    static let HIDE_BTN_SIZE:CGFloat = 25
    static let HIDE_BTN_TOP_MARGIN:CGFloat = 2
    static let HIDE_BTN_RIGHT_MARGIN:CGFloat = 5
    static let ZERO:CGFloat = 0
    
    static let TITLE_FONT_SIZE:CGFloat = 28
    static let TEXT_FONT_SIZE:CGFloat = 14
    static let CORNER_RADIUS:CGFloat = 2
    static let BORDER_WIDTH:CGFloat = 1
  }
}
