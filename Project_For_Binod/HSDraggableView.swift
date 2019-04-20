//
//  HSDraggableView.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/04/20.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit

protocol DraggableViewDelegate:class {
  func panGestureDidChange(_ panGesture:UIPanGestureRecognizer,originalCenter:CGPoint, translation:CGPoint)
  func panGestureDidEnd(_ panGesture:UIPanGestureRecognizer, originalCenter:CGPoint, translation:CGPoint)
  func dTapGesture(tapPoint: CGPoint)
  func tapGesture(sender:UITapGestureRecognizer, tapPoint: CGPoint)
  func longPressGesture(sender:UILongPressGestureRecognizer)
}

class HSDraggableView:HSBaseView {
  
  weak var imageView:UIImageView?
  
  var scollViewZoomScale:CGFloat = 1.0
  
  private var originalPosition:CGPoint = CGPoint(x: 0.0, y: 0.0)
  var delegate:DraggableViewDelegate?
  
  var isPanAction:Bool = true{
    didSet{
      if oldValue != isPanAction {
        self.updatePanAction()
      }
    }
  }
  
  private var panGesture:UIPanGestureRecognizer?
  
  override func didInit() {
    super.didInit()
    self.setUp()
    self.setupConstraints()
    self.updatePanAction()
  }
  
  func setUp(){
    do{
      isUserInteractionEnabled = true
    }
    do{
      let imageView = UIImageView()
      addSubview(imageView)
      self.imageView = imageView
    }
    if let imageView = self.imageView{
      imageView.contentMode = .scaleAspectFit
      imageView.backgroundColor = HSColors.clear
      imageView.isUserInteractionEnabled = true
      let dTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(dTapAction))
      dTapGesture.numberOfTapsRequired = 2
      imageView.addGestureRecognizer(dTapGesture)
    }
    if let imageView = self.imageView{
      let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
      tapGesture.numberOfTapsRequired = 1
      imageView.addGestureRecognizer(tapGesture)
    }
    if let imageView = self.imageView{
      let g = UILongPressGestureRecognizer.init(target: self, action: #selector(longPressAction))
      imageView.addGestureRecognizer(g)
    }
  }
  
  private func setupConstraints(){
    guard let imageView = self.imageView else { return }
    
    imageView.edgesToSuperview()
  }
  
  private func updatePanAction(){
    if panGesture == nil{
      panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction))
      panGesture?.delegate = self
    }
    
    if let panGesture = panGesture{
      if isPanAction{
        self.addGestureRecognizer(panGesture)
      }
      else{
        self.removeGestureRecognizer(panGesture)
      }
    }
  }
}

//MARK: - GestureMethod
extension HSDraggableView{
  @objc func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
    let translation = panGesture.translation(in: superview)
    
    switch panGesture.state {
    case .began:
      originalPosition = self.center
    case .changed:
      self.delegate?.panGestureDidChange(panGesture, originalCenter: originalPosition, translation: translation)
    case .ended:
      self.delegate?.panGestureDidEnd(panGesture, originalCenter: originalPosition, translation: translation)
    default:
      break
    }
  }
  
  @objc func tapAction(sender:UITapGestureRecognizer) {
    let tapPoint = sender.location(in: sender.view)
    self.delegate?.tapGesture(sender: sender, tapPoint: tapPoint)
  }
  
  @objc func dTapAction(sender:UITapGestureRecognizer) {
    let tapPoint = sender.location(in: sender.view)
    self.delegate?.dTapGesture(tapPoint: tapPoint)
  }
  
  @objc func longPressAction(sender:UILongPressGestureRecognizer) {
    self.delegate?.longPressGesture(sender:sender)
  }
}

//MARK: - UIGestureRecognizerDelegate
extension HSDraggableView:UIGestureRecognizerDelegate {
  override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    if let _ = gestureRecognizer as? UIPanGestureRecognizer, scollViewZoomScale == 1.0 {
      return true
    }
    return false
  }
}
