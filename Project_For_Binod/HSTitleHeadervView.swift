//
//  HSTitleHeadervView.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/04/14.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit

class HSTitleHeaderView:UICollectionReusableView{
  //MARK:Elements
  private weak var titleLabel:UILabel?
  var titleString:String?{
    didSet{
      self.titleLabel?.text = titleString
    }
  }
  
  //MARK:Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setup()
    self.setupConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK:Setup
  private func setup(){
    self.backgroundColor  = HSColors.grey.withAlphaComponent(Constants.BACKGROUND_OPACITY)
    
    let titleLabel = UILabel()
    self.titleLabel = titleLabel
    self.addSubview(titleLabel)
    titleLabel.text = "Title Header"
    titleLabel.font = HSFont.heavy(size: 14)
    titleLabel.textColor = HSColors.orange
  }
  
  private func setupConstraints(){
    guard let titleLabel = self.titleLabel
      else {return}
    titleLabel.leftToSuperview(offset:Constants.TITLE_LEFT_MARGIN)
    titleLabel.bottomToSuperview()
  }
}

//MARk:Constants
extension HSTitleHeaderView{
  fileprivate class Constants{
    static let TITLE_LEFT_MARGIN:CGFloat = 10
    static let BACKGROUND_OPACITY:CGFloat = 0.5
  }
}
