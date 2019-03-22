//
//  HSButtonView.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/03/22.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit

class HSButtonView:HSBaseView{
  weak var delegate:HSButtonViewDelegate?
  var e:CGFloat = 0.95
  private var isDown:Bool = false
  var isAnimation:Bool = true
  
  override func didInit() {
    super.didInit()
    
    let gesture = UITapGestureRecognizer(target: self, action: #selector(tapped(sender:)))
    addGestureRecognizer(gesture)
  }
  
  //MARK: - Touches
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let p = touches.first?.location(in: self) else { return }
    let contain = self.bounds.contains(p)
    touchDown(contain)
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {}
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let p = touches.first?.location(in: self) else { return }
    let contain = self.bounds.contains(p)
    touchUp(contain)
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    touchUp(false)
  }
  
  //MARK: - Menu
  func touchDown(_ contain:Bool) {
    self.isDown = true
  }
  
  func touchUp(_ contain:Bool) {
    self.isDown = false
    if (contain) {
      self.delegate?.buttonViewTapped(view: self)
    }
  }
  
  //MARK: - Action
  @objc private func tapped(sender:UITapGestureRecognizer) {
    let p = sender.location(in: self)
    let contain = self.bounds.contains(p)
    if (!self.isDown) {
      touchDown(contain)
    }
    touchUp(contain)
  }
}

protocol HSButtonViewDelegate:NSObjectProtocol {
  func buttonViewTapped(view:HSButtonView)
}
