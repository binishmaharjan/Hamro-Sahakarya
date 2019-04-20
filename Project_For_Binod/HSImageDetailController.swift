//
//  HSImageDetailController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/04/20.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import TinyConstraints

class HSImageDetailController:HSViewController{
  
  var image:UIImage? {
    get{
      return self.mainView?.image
    }
    set(v){
      self.mainView?.image = v
    }
  }
  
  private weak var mainView:HSImageDetailView?
  
  override func didInit() {
    self.view.backgroundColor = HSColors.black
    self.setup()
    self.setupConstraints()
  }
  
  
  private func setup(){
    do{
      let v = HSImageDetailView()
      self.view.addSubview(v)
      self.mainView = v
      v.delegate = self
    }
  }
  
  private func setupConstraints(){
    guard let mainView = self.mainView else{return}
    mainView.edgesToSuperview(usingSafeArea: true)
  }
}

extension HSImageDetailController:HSButtonViewDelegate{
  func buttonViewTapped(view: HSButtonView) {
    if view == self.mainView?.closeBtn{
      self.dismiss(animated: true, completion: nil)
    }
  }
}

extension HSImageDetailController:HSImageDetailViewDelegate {
  func imageDetailViewTap(sender: UITapGestureRecognizer, tapPoint: CGPoint) {}
  
  func imageDetailViewDidPan() {
    self.dismiss(animated: false, completion: nil)
  }
  
  func imageDetailViewLongPress(sender: UILongPressGestureRecognizer) {
    //    showSavePhotoConfirm(image: self.mainView?.image, ok: nil, cancel: nil, failure: nil)
  }
}
