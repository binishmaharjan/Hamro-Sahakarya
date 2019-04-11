//
//  HSTitleCell.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/04/08.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import TinyConstraints

class HSTitleCell:UITableViewCell{
  //MARK:Elements
  private weak var container:UIView?
  private weak var label:UILabel?
  var labelText:String?{
    didSet{
      label?.text = labelText
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
    
    //Label
    let label = UILabel()
    self.label = label
    container.addSubview(label)
    label.text = LOCALIZE("TITLE")
    label.textColor = HSColors.orange
    label.font = HSFont.heavy(size: 14)
    label.textAlignment = .center
  }
  
  private func setupConstraints(){
    guard let container = self.container,
          let label = self.label
      else {return}
    container.edgesToSuperview()
    
    label.centerInSuperview()
    
    container.bottom(to: label,offset:Constants.BOTTOM_MARGIN)
  }
}

//MARK:Constants
extension HSTitleCell{
  fileprivate class Constants{
    static let BOTTOM_MARGIN:CGFloat = 10
  }
}
