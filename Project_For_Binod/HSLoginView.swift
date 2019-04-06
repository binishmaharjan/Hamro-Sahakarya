//
//  HSLoginView.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/03/22.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import TinyConstraints

protocol HSLoginViewDelegate:NSObjectProtocol{
  func doubleFingerDoubleTapped()
}

class HSLoginView:HSBaseView{
  //MARK :Elements
  private weak var scrollView:UIScrollView?
  private weak var contentView:UIView?
  private var contentViewHeightConstraints:Constraint?
  
  private weak var pageTitle:UILabel?
  
  private weak var emailLabel:UILabel?
  private weak var emailBG:UIView?
  weak var emailField:UITextField?
  
  private weak var passwordLabel:UILabel?
  private weak var passwordBG:UIView?
  weak var passwordField:UITextField?
  private weak var hideBG:UIView?
  private weak var hideIcon:UIButton?
  private var isPasswordHidden:Bool = true
  
  private weak var loginBtnBG:UIView?
  weak var loginBtn:HSTextButton?
  
  var delegate:HSLoginViewDelegate?{
    didSet{
      loginBtn?.delegate = delegate as? HSButtonViewDelegate
    }
  }
  
  //MARK:Initializer
  override func didInit() {
    super.didInit()
    self.setup()
    self.setupConstraints()
  }
  
  //MARK:Setups
  private func setup(){
    //double tap gesuture
    let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
    tap.numberOfTapsRequired = 2
    tap.numberOfTouchesRequired = 2
    self.addGestureRecognizer(tap)
    
    //scroll
    let scrollView = UIScrollView()
    self.scrollView = scrollView
    self.addSubview(scrollView)
    
    //contentView
    let contentView = UIView()
    self.contentView = contentView
    scrollView.addSubview(contentView)
    
    
    //titleLabel
    let titleLabel = UILabel()
    self.pageTitle = titleLabel
    let blackAttrs = [NSAttributedString.Key.foregroundColor : HSColors.black]
    let orangeAttrs = [NSAttributedString.Key.foregroundColor : HSColors.orange]
    let titleText = NSMutableAttributedString(string: "Welcome ", attributes: blackAttrs)
    let orangeText = NSMutableAttributedString(string: "User", attributes: orangeAttrs)
    titleText.append(orangeText)
    titleLabel.attributedText = titleText
    titleLabel.font = HSFont.heavy(size: Constants.TITLE_FONT_SIZE)
    contentView.addSubview(titleLabel)
    
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
    
    //hide icon
    let hideBG = UIView()
    self.hideBG = hideBG
    passwordBG.addSubview(hideBG)
    
    let hideIcon = UIButton()
    self.hideIcon = hideIcon
    hideIcon.setImage(UIImage(named: "icon_hide"), for: .normal)
    hideIcon.addTarget(self, action: #selector(hideBtnPressed), for: .touchUpInside)
    hideBG.addSubview(hideIcon)
    
    //login btn
    let loginBtnBG = UIView()
    self.loginBtnBG = loginBtnBG
    loginBtnBG.backgroundColor = HSColors.orange
    loginBtnBG.layer.cornerRadius = Constants.CORNER_RADIUS
    contentView.addSubview(loginBtnBG)
    
    let loginBtn = HSTextButton()
    self.loginBtn = loginBtn
    loginBtn.text = LOCALIZE("Login")
    loginBtn.textColor = HSColors.white
    loginBtn.font = HSFont.bold(size: Constants.TEXT_FONT_SIZE)
    loginBtnBG.addSubview(loginBtn)
  }
  
  private func setupConstraints(){
    guard let scrollView = self.scrollView,
          let contentView = self.contentView,
          let titleLabel = self.pageTitle,
          let emailLabel = self.emailLabel,
          let emailBG = self.emailBG,
          let emailField = self.emailField,
          let passwordLabel = self.passwordLabel,
          let passwordField = self.passwordField,
          let passwordBG = self.passwordBG,
          let hideBG = self.hideBG,
          let hideIcon = self.hideIcon,
          let loginBtnBG = self.loginBtnBG,
          let loginBtn = self.loginBtn
      else {return}
    
    scrollView.edgesToSuperview()
    contentView.edgesToSuperview()
    contentView.width(to: scrollView)
    
    titleLabel.topToSuperview(offset: Constants.TITLE_LABEL_TOP_MARGIN)
    titleLabel.leftToSuperview(offset: Constants.LEFT_MARGIN)
    
    emailLabel.left(to: titleLabel)
    emailLabel.topToBottom(of: titleLabel, offset:Constants.TITLE_LABEL_BOTTOM_MARGIN)
    
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
    passwordBG.left(to: emailBG)
    passwordBG.right(to: emailBG)
    passwordBG.height(Constants.TEXT_FIELD_HEIGHT)
    
    passwordField.edgesToSuperview(excluding: .right,insets:UIEdgeInsets(top: Constants.ZERO,
                                                       left: Constants.TEXT_FIELD_HOR_INSETS,
                                                       bottom: Constants.ZERO,
                                                       right: Constants.TEXT_FIELD_HOR_INSETS))
    passwordField.rightToLeft(of: hideBG)
    
    hideBG.edgesToSuperview(excluding: .left,insets: UIEdgeInsets(top: Constants.HIDE_BTN_TOP_MARGIN,
                                                                  left: Constants.ZERO,
                                                                  bottom: Constants.HIDE_BTN_TOP_MARGIN,
                                                                  right: Constants.HIDE_BTN_RIGHT_MARGIN))
    hideBG.width(Constants.HIDE_BTN_SIZE)
    
    hideIcon.edgesToSuperview()
    
    
    loginBtnBG.topToBottom(of: passwordBG, offset: Constants.BUTTON_TOP_MARGIN)
    loginBtnBG.left(to: emailBG)
    loginBtnBG.right(to: emailBG)
    loginBtnBG.height(Constants.BUTTON_HEIGHT)
    
    loginBtn.edgesToSuperview()
    
    contentView.bottom(to: loginBtn)
  }
}

//MARK:TextFieldDelegaete
extension HSLoginView:UITextFieldDelegate{
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == emailField{
      passwordField?.becomeFirstResponder()
    }
    if textField == passwordField{
      textField.resignFirstResponder()
    }
    return true
  }
}

//MARK:Button
extension HSLoginView{
  @objc func hideBtnPressed(){
    isPasswordHidden = !isPasswordHidden
    hideIcon?.setImage(isPasswordHidden ? UIImage(named: "icon_hide") : UIImage(named: "icon_hidden"), for: .normal)
    passwordField?.isSecureTextEntry = isPasswordHidden
  }
}

//MARK:Admin Login
extension HSLoginView{
  @objc func doubleTapped(){
    delegate?.doubleFingerDoubleTapped()
  }
}

//MARK: Constants
extension HSLoginView{
  fileprivate class Constants{
    static let TITLE_LABEL_TOP_MARGIN:CGFloat = 100
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
