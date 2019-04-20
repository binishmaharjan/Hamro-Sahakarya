//
//  HSImageDetailView.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/04/20.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import TinyConstraints

protocol HSImageDetailViewDelegate {
  func imageDetailViewDidPan()
  func imageDetailViewTap(sender:UITapGestureRecognizer, tapPoint: CGPoint)
  func imageDetailViewLongPress(sender:UILongPressGestureRecognizer)
}

class HSImageDetailView: HSBaseView {
  
  var image:UIImage?{
    didSet{
      self.setNeedsUpdateConstraints()
    }
  }
  
  private var cancelButtonBG: UIView?
  weak var closeBtn:HSImageButtonView?
  
  weak var scrollView:UIScrollView?
  weak var draggableView:HSDraggableView?
  var draggableViewScrollWidthConst:Constraint?
  var draggableViewScrollHeightConst:Constraint?
  var draggableViewWidthConst:Constraint?
  var draggableViewHeightConst:Constraint?
  
  private var resetZoomScale:CGFloat = 1.0
  
  var delegate:HSImageDetailViewDelegate?{
    didSet{
      self.closeBtn?.delegate = delegate as? HSButtonViewDelegate
    }
  }
  
  override func didInit() {
    super.didInit()
    self.backgroundColor = HSColors.black
    self.setup()
    self.setupConstraints()
  }
  
  override func updateConstraints() {
    self.relayout()
    super.updateConstraints()
  }
  
  private func setup(){
    do{
      let scrollView = UIScrollView()
      self.addSubview(scrollView)
      self.scrollView = scrollView
      scrollView.delegate = self
      scrollView.minimumZoomScale = 1
      scrollView.maximumZoomScale = 8
      scrollView.isScrollEnabled = true
      scrollView.showsHorizontalScrollIndicator = true
      scrollView.showsVerticalScrollIndicator = true
    }
    if let scrollView = scrollView{
      let draggableView = HSDraggableView()
      scrollView.addSubview(draggableView)
      self.draggableView = draggableView
      draggableView.delegate = self
    }
    do{
      let cancelButtonBG = UIView()
      self.cancelButtonBG = cancelButtonBG
      cancelButtonBG.layer.cornerRadius = 30 / 2
      cancelButtonBG.backgroundColor = HSColors.white.withAlphaComponent(0.3)
      cancelButtonBG.isUserInteractionEnabled = true
      self.addSubview(cancelButtonBG)
      
      let closeBtn = HSImageButtonView()
      cancelButtonBG.addSubview(closeBtn)
      self.closeBtn = closeBtn
      let image = UIImage(named: "icon_close")
      closeBtn.image = image
    }
  }
  
  private func setupConstraints(){
    guard let scrollView = self.scrollView,
      let draggableView = self.draggableView,
      let closeBtn = self.closeBtn,
      let cancelButtonBG = self.cancelButtonBG else { return }
    
    do{
      scrollView.edgesToSuperview()
    }
    do{
      draggableView.edgesToSuperview()
      self.draggableViewScrollWidthConst = draggableView.width(to:scrollView, isActive:false)
      self.draggableViewScrollHeightConst = draggableView.height(to:scrollView, isActive:false)
      self.draggableViewWidthConst = draggableView.width(0, isActive:false)
      self.draggableViewHeightConst = draggableView.height(0, isActive:false)
    }
    do{
      cancelButtonBG.topToSuperview(offset : 32)
      cancelButtonBG.leftToSuperview(offset : 16)
      cancelButtonBG.width(30)
      cancelButtonBG.height(to: cancelButtonBG, cancelButtonBG.widthAnchor)
      
      closeBtn.edgesToSuperview()
    }
  }
  
  private func relayout(){
    
    guard
      let scrollView = self.scrollView,
      let draggableView = self.draggableView,
      let draggableViewScrollWidthConst = self.draggableViewScrollWidthConst,
      let draggableViewScrollHeightConst = self.draggableViewScrollHeightConst,
      let draggableViewWidthConst = self.draggableViewWidthConst,
      let draggableViewHeightConst = self.draggableViewHeightConst,
      let image = self.image
      else{
        return
    }
    
    draggableView.imageView?.image = image
    
    var minScale:CGFloat = 1.0
    var zoomScale:CGFloat = 1.0
    
    draggableViewScrollWidthConst.isActive = false
    draggableViewScrollHeightConst.isActive = false
    draggableViewWidthConst.isActive = false
    draggableViewHeightConst.isActive = false
    
    if draggableView.imageView?.contentMode == UIView.ContentMode.scaleAspectFit{
      draggableViewScrollWidthConst.isActive = true
      draggableViewScrollHeightConst.isActive = true
    }
    else{
      draggableViewWidthConst.isActive = true
      draggableViewHeightConst.isActive = true
      draggableViewWidthConst.constant = image.size.width
      draggableViewHeightConst.constant = image.size.height
      
      zoomScale = scrollView.bounds.height / image.size.height
      minScale = zoomScale
      if zoomScale * image.size.width > scrollView.bounds.width{
        minScale = scrollView.bounds.width / image.size.width
      }
    }
    self.setNeedsLayout()
    self.layoutIfNeeded()
    
    scrollView.minimumZoomScale = minScale
    scrollView.maximumZoomScale = max(8 * minScale, zoomScale)
    //0.5sec待たないと画像を再読み込みするとずれる
    //draggableViewのalpha=0にしないと一瞬サイズがおかしい画像が見える
    self.draggableView?.alpha = 0
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      self.draggableView?.alpha = 1
      self.scrollView?.setZoomScale(zoomScale, animated: false)
    }
  }
  
  
  private func updateScrollInset(){
    guard
      let scrollView = self.scrollView,
      let draggableView = draggableView else {
        return
    }
    // imageViewの大きさからcontentInsetを再計算
    // なお、0を下回らないようにする
    scrollView.contentInset = [
      max((scrollView.frame.height - draggableView.frame.height)/2, 0),
      max((scrollView.frame.width - draggableView.frame.width)/2, 0),
      0,
      0
      ].uiEdgeInsets
  }
}

extension HSImageDetailView: DraggableViewDelegate{
  
  func panGestureDidChange(_ panGesture: UIPanGestureRecognizer, originalCenter: CGPoint, translation: CGPoint) {
    guard let draggableView = self.draggableView else { return }
    draggableView.frame.origin.y = translation.y
  }
  
  func panGestureDidEnd(_ panGesture: UIPanGestureRecognizer, originalCenter: CGPoint, translation: CGPoint) {
    guard let draggableView = self.draggableView else { return }
    
    if draggableView.center.y >= draggableView.bounds.height * 0.6 {
      UIView.animate(withDuration: 0.3, animations: {
        draggableView.frame.origin.y = self.bounds.height
      }, completion: { (finished) in
        self.delegate?.imageDetailViewDidPan()
      })
    } else if draggableView.center.y <= draggableView.bounds.height * 0.3 {
      UIView.animate(withDuration: 0.3, animations: {
        draggableView.frame.origin.y = self.bounds.origin.y - draggableView.frame.height
      }, completion: { (finished) in
        self.delegate?.imageDetailViewDidPan()
      })
    } else {
      UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9, options: .curveEaseInOut, animations: {
        draggableView.center = originalCenter
      }, completion: nil)
    }
  }
  
  func dTapGesture(tapPoint: CGPoint) {
    guard let scrollView = self.scrollView else { return }
    if scrollView.zoomScale < scrollView.maximumZoomScale {
      let newScale:CGFloat = scrollView.zoomScale * 3
      let zoomRect:CGRect = self.zoomRectForScale(scale: newScale, center: tapPoint)
      scrollView.zoom(to: zoomRect, animated: true)
    }
    else {
      scrollView.setZoomScale(1.0, animated: true)
    }
  }
  
  func tapGesture(sender: UITapGestureRecognizer, tapPoint: CGPoint) {
    self.delegate?.imageDetailViewTap(sender: sender, tapPoint: tapPoint)
  }
  
  func longPressGesture(sender: UILongPressGestureRecognizer) {
    self.delegate?.imageDetailViewLongPress(sender: sender)
  }
}

extension HSImageDetailView:UIScrollViewDelegate {
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return draggableView
  }
  
  func zoomRectForScale(scale:CGFloat, center: CGPoint) -> CGRect{
    guard let scrollView = self.scrollView else { return .zero }
    var zoomRect: CGRect = .zero
    zoomRect.size.height = scrollView.bounds.height / scale
    zoomRect.size.width = scrollView.bounds.width / scale
    zoomRect.origin.x = center.x - zoomRect.size.width / 2.0
    zoomRect.origin.y = center.y - zoomRect.size.height / 2.0
    return zoomRect
  }
  
  func scrollViewDidZoom(_ scrollView: UIScrollView) {
    self.updateScrollInset()
  }
  
  func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
    self.draggableView?.scollViewZoomScale = scrollView.zoomScale
  }
}
