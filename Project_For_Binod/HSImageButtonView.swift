//
//  HSImageButtonView.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/03/22.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import TinyConstraints

class HSImageButtonView:HSButtonView{
  weak var imageView:UIImageView?
  private var imageWidthConst:Constraint?
  private var imageHeightConst:Constraint?
  private var buttonWidthConst:Constraint?
  private var buttonHeightConst:Constraint?
  
  var buttonMargin:CGSize = .zero{
    didSet{
      guard
        let buttonWidthConst = buttonWidthConst,
        let buttonHeightConst = buttonHeightConst
        else{
          return
      }
      buttonWidthConst.constant = buttonMargin.width
      buttonHeightConst.constant = buttonMargin.height
      self.setNeedsUpdateConstraints()
    }
  }
  
  var imageSize:CGSize = .zero{
    didSet{
      guard
        let imageWidthConst = imageWidthConst,
        let imageHeightConst = imageHeightConst else{
          return
      }
      
      if imageSize == .zero, let size = self.imageView?.image?.size {
        imageWidthConst.constant = size.width
      }
      else{
        imageWidthConst.constant = imageSize.width
      }
      
      if imageSize == .zero, let size = self.imageView?.image?.size {
        imageHeightConst.constant = size.height
      }
      else{
        imageHeightConst.constant = imageSize.height
      }
      self.setNeedsUpdateConstraints()
    }
  }
  
  var image:UIImage?{
    get{
      return self.imageView?.image
    }
    set(v){
      self.imageView?.image = v
      if imageSize == .zero, let size = v?.size{
        self.imageSize = size
      }
    }
  }
  
  override var tintColor: UIColor!{
    get{
      return self.imageView?.tintColor
    }
    set(v){
      self.imageView?.tintColor = v
    }
  }
  
  override var backgroundColor: UIColor?{
    didSet{
      self.imageView?.backgroundColor = backgroundColor
    }
  }
  
  override func didInit() {
    super.didInit()
    self.setup()
  }
  
  private func setup(){
    let iv = UIImageView()
    self.addSubview(iv)
    self.imageView = iv
    iv.contentMode = .scaleAspectFit
    iv.centerInSuperview()
    self.imageWidthConst = iv.width(0, priority: LayoutPriority.defaultHigh)
    self.imageHeightConst = iv.height(0, priority: LayoutPriority.defaultHigh)
    self.buttonWidthConst = self.width(to: iv, offset:8)
    self.buttonHeightConst = self.height(to: iv, offset:14)
  }
  
  
  override func touchDown(_ contain: Bool) {
    super.touchDown(contain)
    if isAnimation{
      UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
        self.imageView?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
      })
    }
  }
  
  override func touchUp(_ contain: Bool) {
    super.touchUp(contain)
    if isAnimation{
      UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseInOut, animations: {
        self.imageView?.transform = .identity
      })
    }
  }
}
