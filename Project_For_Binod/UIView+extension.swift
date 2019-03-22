//
//  UIView+extension.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/03/22.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
let DEF_SHADOW_COLOR = UIColor(red:0, green:0, blue:0, alpha:1)
let DEF_SHADOW_OPACITY:Float = 0.1
let DEF_SHADOW_OFFSET:CGSize = CGSize(width:0, height:2)
let DEF_SHADOW_RADIUS:CGFloat = 4.0

extension UIView{
  
  var isDrawRectangle:Bool{
    get{
      return self.layer.borderWidth > 1
    }
    set(value){
      if(value){
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.borderWidth = 1
      }
      else{
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 0
      }
    }
  }
  
  func dropShadow(
    color:UIColor = DEF_SHADOW_COLOR
    ,opacity:Float = DEF_SHADOW_OPACITY
    ,offset:CGSize = DEF_SHADOW_OFFSET
    ,radius:CGFloat = DEF_SHADOW_RADIUS) {
    self.layer.shadowColor = color.cgColor
    self.layer.shadowOpacity = opacity
    self.layer.shadowOffset = offset
    self.layer.shadowRadius = radius
    self.layer.shouldRasterize = true
    self.layer.rasterizationScale = UIScreen.main.scale
  }
  
  func applyGradient(colors: [CGColor])
  {
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = colors
    gradientLayer.startPoint = CGPoint(x: 0, y: 0)
    gradientLayer.endPoint = CGPoint(x: 1, y: 0)
    gradientLayer.frame = self.bounds
    self.layer.addSublayer(gradientLayer)
  }
}

