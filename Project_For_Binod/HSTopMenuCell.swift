//
//  HSTopMenuCell.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/04/06.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import TinyConstraints


class HSTopMenuCell:UICollectionViewCell{
  ///MARK:Elements
  private weak var menuTitleLabel:UILabel?
  
  //MARK:INit
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
    let menuTitleLabel = UILabel()
    self.menuTitleLabel = menuTitleLabel
    self.addSubview(menuTitleLabel)
    menuTitleLabel.text = LOCALIZE("Menu")
    menuTitleLabel.font = HSFont.bold(size: 14)
    menuTitleLabel.textAlignment = .center
    menuTitleLabel.textColor = HSColors.black
  }
  
  private func setupConstraints(){
    guard let menuTitleLabel = self.menuTitleLabel
      else {return}
    
    menuTitleLabel.edgesToSuperview()
  }
  
  func setTitle(title:String){
    guard let menuTitleLabel = self.menuTitleLabel
      else {return}
    menuTitleLabel.text = LOCALIZE(title)
  }
}
