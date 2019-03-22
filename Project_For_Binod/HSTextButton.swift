//
//  HSTextButton.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/03/22.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import TinyConstraints

class HSTextButton:HSButtonView{
  private weak var base:UIView?
  weak var label:UILabel?
  
  private var baseInsetsConstraints:Constraints?
  
  var edgeInsets:TinyEdgeInsets=[-7.0, -4.0, 7.0, 4.0].uiEdgeInsets{
    didSet{
      guard let baseInsetsConstraints = baseInsetsConstraints, baseInsetsConstraints.count >= 4 else { return }
      baseInsetsConstraints[0].constant = edgeInsets.top
      baseInsetsConstraints[1].constant = edgeInsets.left
      baseInsetsConstraints[2].constant = edgeInsets.bottom
      baseInsetsConstraints[3].constant = edgeInsets.right
    }
  }
  
  var numberOfLines:Int{
    get{return self.label?.numberOfLines ?? 0}
    set(v){self.label?.numberOfLines = v}
  }
  
  var baseCornerRadius:CGFloat{
    get{return self.base?.layer.cornerRadius ?? 0}
    set(v){ self.base?.layer.cornerRadius = v }
  }
  
  var attributedText:NSAttributedString? {
    get { return self.label?.attributedText }
    set(v) {
      guard let lbl = self.label else { return }
      lbl.attributedText = v
      lbl.sizeToFit()
    }
  }
  
  var text:String? {
    get { return self.label?.text }
    set(v) {
      guard let lbl = self.label else { return }
      lbl.text = v
    }
  }
  
  var font:UIFont?{
    get { return self.label?.font }
    set(v) {
      guard let lbl = self.label else { return }
      lbl.font = v
    }
  }
  
  var color:UIColor?{
    get { return self.base?.backgroundColor }
    set(v) {
      self.backgroundColor = v
      self.base?.backgroundColor = v
    }
  }
  
  var textColor:UIColor?{
    get { return self.label?.textColor }
    set(v) { self.label?.textColor = v }
  }
  
  override func didInit() {
    super.didInit()
    self.setup()
    self.setupConstraints()
    
    self.font = HSFont.bold(size: 14)
    self.textColor = HSColors.white
    self.baseCornerRadius = 4
  }
  
  private func setup(){
    let base = UIView()
    self.addSubview(base)
    self.base = base
    base.clipsToBounds = true
    do{
      let label = UILabel()
      base.addSubview(label)
      self.label = label
    }
  }
  
  private func setupConstraints(){
    guard
      let base = self.base
      ,let label = self.label
      else{ return }
    
    label.centerInSuperview()
    
    //    baseInsetsConstraints = [
    //      base.top(to: label, offset: edgeInsets.top)
    //      ,base.left(to: label, offset: edgeInsets.left)
    //      ,base.bottom(to: label, offset: edgeInsets.bottom)
    //      ,base.right(to: label, offset: edgeInsets.right)
    //    ]
    base.centerInSuperview()
    
    self.width(to: base)
    self.height(to: base)
  }
  
  //MARK: - Animation
  override func touchDown(_ contain: Bool) {
    super.touchDown(contain)
    if isAnimation{
      UIView.animate(withDuration: 0.2) {
        self.base?.transform = CGAffineTransform(scaleX:self.e, y:self.e)
      }
    }
  }
  
  override func touchUp(_ contain: Bool) {
    super.touchUp(contain)
    if isAnimation{
      UIView.animate(withDuration: 0.2, delay: 0.2, options: UIView.AnimationOptions.curveEaseInOut, animations: {
        self.base?.transform = CGAffineTransform.identity
      }, completion: nil)
    }
  }
}
