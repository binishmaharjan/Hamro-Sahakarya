//
//  HSSettingMenuCell.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/04/20.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import TinyConstraints

class HSSettingMenuCell:UICollectionViewCell{
  //MARK Elements
  private weak var container:UIView?
  private weak var titleLabel:UILabel?
  private weak var border:UIView?
  
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
    let container = UIView()
    self.container = container
    self.addSubview(container)
    
    let titleLabel = UILabel()
    self.titleLabel = titleLabel
    titleLabel.text = ""
    titleLabel.font = HSFont.normal(size: 14)
    titleLabel.textColor = HSColors.black
    container.addSubview(titleLabel)
    
    let border = UIView()
    self.border = border
    container.addSubview(border)
    border.backgroundColor = HSColors.black
  }
  
  private func setupConstraints(){
    guard let container = self.container,
          let titleLabel = self.titleLabel,
          let border = self.border
      else {return}
    
    container.edgesToSuperview()
    
    titleLabel.edgesToSuperview(insets:Constants.TITLE_INSETS)
    
    border.edgesToSuperview(excluding:.top)
    border.height(Constants.BORDER_HEIGHT)
  }
}

//MARk:Constants
extension HSSettingMenuCell{
  fileprivate class Constants{
    static let BORDER_HEIGHT:CGFloat = 0.5
    static let TITLE_INSETS:UIEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
  }
}
