//
//  HSActivityIndicator.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/04/04.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import TinyConstraints

enum HSActiviyIndicatorType:String{
  case loading = "Loading"
  case wait = "Please Wait"
}

class HSActivityIndicator{
  //MARK:Variable
  
  var background:UIView?
  var indicatorBackground:UIView?
  var activityIndicator:UIActivityIndicatorView?
  var displayLabel:UILabel?
  
  private init(){}
  
  static let shared:HSActivityIndicator = HSActivityIndicator()
  
  func start(view:UIView){
    
    background = UIView()
    background?.backgroundColor = HSColors.black.withAlphaComponent(0.3)
    view.addSubview(background!)
    
    indicatorBackground = UIView()
    indicatorBackground?.backgroundColor = UIColor.white
    indicatorBackground?.layer.cornerRadius = 2
    indicatorBackground?.layer.shadowColor = HSColors.black.cgColor
    indicatorBackground?.layer.shadowOpacity = 0.5
    indicatorBackground?.shadowOffset = CGSize(width: 0, height: 0)
    indicatorBackground?.shadowRadius = 1
    background?.addSubview(indicatorBackground!)
    
    activityIndicator = UIActivityIndicatorView()
    activityIndicator?.style = .whiteLarge
    activityIndicator?.color = HSColors.orange
    indicatorBackground?.addSubview(activityIndicator!)
    
    displayLabel = UILabel()
    displayLabel?.text = LOCALIZE("Please Wait")
    displayLabel?.textColor = HSColors.orange
    displayLabel?.font = HSFont.bold(size: 18)
    displayLabel?.textAlignment = .center
    indicatorBackground?.addSubview(displayLabel!)
    
    //Constraints
    background?.edgesToSuperview()
    
    indicatorBackground?.centerYToSuperview()
    indicatorBackground?.height(72)
    indicatorBackground?.leftToSuperview(offset:30)
    indicatorBackground?.rightToSuperview(offset:-30)
    
    activityIndicator?.leftToSuperview(offset:8)
    activityIndicator?.width(72)
    activityIndicator?.height(72)
    
    displayLabel?.edgesToSuperview()
    
    if !(activityIndicator?.isAnimating)!{
      activityIndicator?.startAnimating()
    }
  }
  
  func stop(){
    activityIndicator?.stopAnimating()
    //Remove All view
    [activityIndicator,displayLabel,indicatorBackground,background].forEach { (view) in
      view?.removeFromSuperview()
    }
  }
}
