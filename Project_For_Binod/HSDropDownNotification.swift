//
//  HSDropDownNotification.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/03/25.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import TinyConstraints

enum HSDropDownType{
  case error
  case success
  case normal
}

class HSDropDownNotification:HSBaseView{
  
  let TH_BOTTOM:CGFloat = 60.0
  let TH_ABOVE:CGFloat = (SAFE_AREA_TOP_INSETS ?? 0.0) + 7.0
  let W:CGFloat = UIScreen.main.bounds.size.width - 21.0
  let H:CGFloat = 60.0
  
  weak var label:UILabel? = nil
  var text:String=""{
    didSet{
      label?.text = text
    }
  }
  
  var type:HSDropDownType = .normal{
    didSet{
      if type == .normal{self.backgroundColor = HSColors.black.withAlphaComponent(0.5)}
      if type == .success{self.backgroundColor = UIColor.green.withAlphaComponent(0.5)}
      if type == .error{self.backgroundColor = UIColor.red.withAlphaComponent(0.5)}
    }
  }
  
  override func didInit() {
    super.didInit()
    
    self.frame = CGRect(x:0, y:0, width:self.W, height:self.H)
//    self.backgroundColor = HSColors.black
    self.clipsToBounds = true
    self.layer.cornerRadius = 5.0
    
    let lbl = UILabel()
    self.label = lbl
    lbl.font = HSFont.bold(size: 15.0)
    lbl.textColor = HSColors.white
    lbl.numberOfLines = 0
    lbl.text = LOCALIZE("Drop Down")
    lbl.width = self.width
    lbl.textAlignment = .center
    lbl.height = 99999
    lbl.center = self.o
    self.addSubview(lbl)
    
    self.center.x = UIScreen.main.bounds.size.width / 2.0
    self.bottom = 0
    
    // gesture
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(viewTapped(_:)))
    self.addGestureRecognizer(tapGestureRecognizer)
    let panGesture = UIPanGestureRecognizer.init(target: self, action:#selector(dragGesture(_ :)))
    self.addGestureRecognizer(panGesture)
    
    // animation
    UIView.animate(withDuration: 0.2, delay: 0.5, options: [.curveEaseInOut, .allowUserInteraction], animations: {
      self.y = self.TH_ABOVE
    }, completion: nil)
    UIView.animate(withDuration: 0.2, delay: 3.5, options: [.curveEaseInOut, .allowUserInteraction], animations: {
      self.alpha = 0.1
    }, completion: {(value: Bool) in
      self.removeFromSuperview()
    })
  }
  
  
  @objc func viewTapped(_ sender: UITapGestureRecognizer){
    
  }
  
  @objc func dragGesture(_ sender: UIPanGestureRecognizer) {
    
    let point: CGPoint = sender.translation(in: self)
    var movedPoint: CGPoint = CGPoint(x: self.center.x,
                                      y: sender.view!.center.y + point.y)
    if movedPoint.y > TH_BOTTOM {
      movedPoint.y = TH_BOTTOM
    }
    
    if sender.state == .ended{
      if movedPoint.y < TH_ABOVE + self.H / 2.0{
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
          self.bottom = 0.0
        }, completion:
          {(value: Bool) in
            self.removeFromSuperview()
        })
        return
      }
      UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
        movedPoint.y = self.TH_ABOVE + self.H / 2.0
      }, completion: nil)
    }
    sender.view!.center = movedPoint
    sender.setTranslation(CGPoint.zero, in: self)
  }
  
  @objc func setupPanGestures(swipeGestures: [UISwipeGestureRecognizer]) {
    let panGesture = UIPanGestureRecognizer.init(target: self, action:#selector(dragGesture(_ :)))
    self.addGestureRecognizer(panGesture)
  }
}
