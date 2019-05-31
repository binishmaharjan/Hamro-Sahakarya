//
//  HSSettingView.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/04/14.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import TinyConstraints

protocol HSSettingDelegate:NSObjectProtocol{
  func changeProfilePicturePressed()
  func changePasswordPressed()
  func requestForLoanPressed()
  func termsAndConditionPressed()
  func privacyPolicyPressed()
  func logoutPressed()
  //Admin Menu
  func addAmountPressed()
  func addMonthlyFeePressed()
  func loanMemberPressed()
  func loanReturnedPressed()
  func addExpensePressed()
  func addExtraPressed()
  func deleteUserPressed()
  func makeAdminPressed()
  func removeAdminPressed()
}

class HSSettingView:HSBaseView{
  //Elements
  private weak var header:UIView?
  private weak var titleLabel:UILabel?
  private weak var backIconBG:UIView?
  weak var backIcon:HSImageButtonView?
  
  private weak var collectionView:UICollectionView?
  
  typealias CELL1 = HSSettingMenuCell
  let CELL1_CLASS = CELL1.self
  let CELL1_ID = NSStringFromClass(CELL1.self)
  
  typealias HEADER1 = HSImageHeaderView
  let HEADER1_CLASS = HEADER1.self
  let HEADER1_ID = NSStringFromClass(HEADER1.self)
  
  typealias HEADER2 = HSTitleHeaderView
  let HEADER2_CLASS = HEADER2.self
  let HEADER2_ID = NSStringFromClass(HEADER2.self)
  
  var imageHeader:HSImageHeaderView?
  
  var delegate:HSButtonViewDelegate?{
    didSet{
      backIcon?.delegate = delegate
    }
  }
  
  //Menu Items
  private let sectionTitle:[String] = ["Users","Others","Admin"]
  private let userMenu:[String] = ["Change Picture","Change Password"]
  private let otherMenu:[String] = ["Terms & Conditon","Privacy Policy","Logout"]
  private let adminMenu:[String] = ["Add Amount","Add Monthly Fee","Loan a Member","Loan Returned","Add Expense","Add Extra","Delete User","Make Admin","Remove Admin"]

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
    titleLabel.text = LOCALIZE("Setting")
    titleLabel.font = HSFont.heavy(size: 14)
    titleLabel.textColor = HSColors.black
    titleLabel.textAlignment = .center
    
    let backIconBG = UIView()
    self.backIconBG = backIconBG
    header.addSubview(backIconBG)
    
    let backIcon = HSImageButtonView()
    self.backIcon = backIcon
    backIconBG.addSubview(backIcon)
    backIcon.image = UIImage(named: "icon_back")
    backIcon.buttonMargin = .zero
    
    //CollectionView
    let layout = HSStretchyHeaderLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    self.collectionView = collectionView
    self.addSubview(collectionView)
    collectionView.backgroundColor = HSColors.white
    collectionView.register(CELL1_CLASS, forCellWithReuseIdentifier: CELL1_ID)
    collectionView.register(HEADER1_CLASS, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HEADER1_ID)
    collectionView.register(HEADER2_CLASS, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HEADER2_ID)
    collectionView.delegate = self
    collectionView.dataSource = self
  }
  
  private func setupConstraints(){
    guard let header = self.header,
          let titleLabel = self.titleLabel,
          let backIcon = self.backIcon,
          let backIconBG = self.backIconBG,
          let collectionView = self.collectionView
      else {return}
    
    header.edgesToSuperview(excluding:.bottom)
    header.height(Constants.HEADER_HEIGHT)
    
    titleLabel.centerInSuperview()
    
    backIconBG.leftToSuperview(offset:Constants.BACK_ICON_MARGIN)
    backIconBG.centerYToSuperview()
    backIconBG.width(Constants.BACK_ICON_SIZE)
    backIconBG.height(to: backIconBG,backIconBG.widthAnchor)
    
    backIcon.edgesToSuperview()
    
    collectionView.edgesToSuperview(excluding:.top)
    collectionView.topToBottom(of: header)
  }
}

//MARK:CollectionView Delegate & Datasource
extension HSSettingView:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate{
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    print(HSSessionManager.shared.user?.username)
    if let user = HSSessionManager.shared.user,
      user.status == HSUserType.member.rawValue {
      return 2
    }
    return sectionTitle.count
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch section {
    case 0:
      return userMenu.count
    case 1:
      return otherMenu.count
    case 2:
      return adminMenu.count
    default:
      return 0
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL1_ID, for: indexPath) as? CELL1,
      indexPath.section == 0
    {
      cell.titleString = userMenu[indexPath.row]
      return cell
    }
    
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL1_ID, for: indexPath) as? CELL1,
      indexPath.section == 1
    {
      cell.titleString = otherMenu[indexPath.row]
      return cell
    }
    
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL1_ID, for: indexPath) as? CELL1,
      indexPath.section == 2
    {
      cell.titleString = adminMenu[indexPath.row]
      return cell
    }
    
    return UICollectionViewCell()
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: self.frame.width, height: 50)
  }
  
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let delegate = self.delegate as? HSSettingDelegate else {return}
    switch (indexPath.section,indexPath.row) {
    case (0,0):
      delegate.changeProfilePicturePressed()
    case (0,1):
      delegate.changePasswordPressed()
    case (0,2):
      delegate.requestForLoanPressed()
    case (1,0):
      delegate.termsAndConditionPressed()
    case (1,1):
      delegate.privacyPolicyPressed()
    case (1,2):
      delegate.logoutPressed()
    case (2,0):
      delegate.addAmountPressed()
    case (2,1):
      delegate.addMonthlyFeePressed()
    case (2,2):
      delegate.loanMemberPressed()
    case (2,3):
      delegate.loanReturnedPressed()
    case (2,4):
      delegate.addExpensePressed()
    case (2,5):
      delegate.addExtraPressed()
    case (2,6):
      delegate.deleteUserPressed()
    case (2,7):
      delegate.makeAdminPressed()
    case (2,8):
      delegate.removeAdminPressed()
    default:
      Dlog()
    }
  }
  /*
   Necessary Files and Method For Stretchy Header
   HSImageHeaderView
   HSStretchyHeaderLayout
   
   collectionView:viewForSupplementaryElementOfKind
   collectionView:referenceSizeForHeaderInSection
   scrollView:scrollViewDidScroll
 */
    //HEADER
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    //Image Header
    if indexPath.section == 0,
      let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HEADER1_ID, for: indexPath) as? HEADER1{
      self.imageHeader = header
      header.titleString = self.sectionTitle[indexPath.section]
      return header
    }
    
    //Title Header
    if indexPath.section > 0,
      let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HEADER2_ID, for: indexPath) as? HEADER2{
      header.titleString = self.sectionTitle[indexPath.section]
      return header
    }
    
    return UICollectionReusableView()
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    if section == 0 {
      return .init(width: self.frame.width, height: 150)
    }else{
      return .init(width: self.frame.width, height: 25)
    }
  }
  
  //Scroll
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let contentViewOffsetY = scrollView.contentOffset.y
    if contentViewOffsetY > 0{
      imageHeader?.animator.fractionComplete = 0
      return
    }
    imageHeader?.animator.fractionComplete = abs(contentViewOffsetY) / 300
  }
}


//MARK:Constants
extension HSSettingView{
  fileprivate class Constants{
    static let HEADER_HEIGHT:CGFloat = 44
    static let BACK_ICON_SIZE:CGFloat = 22
    static let BACK_ICON_MARGIN:CGFloat = 12
  }
}
