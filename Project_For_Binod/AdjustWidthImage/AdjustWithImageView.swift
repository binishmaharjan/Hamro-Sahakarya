//
//  AdjustWithImageView.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/01/20.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit

/*
 UIImage View that automatically readjust its size with when the new image is set
 */
final class AdjustWithImageView: UIImageView {
  
  override var intrinsicContentSize: CGSize {
    guard let img = image else { return .zero }
    
    let gcdValue = gcd(Int(img.size.width), Int(img.size.height))
    let widthAspect = img.size.width / CGFloat(gcdValue)
    let heightAspect = img.size.height / CGFloat(gcdValue)
    
    let baseValue = self.bounds.width / widthAspect
    
    return CGSize(width: baseValue * widthAspect, height: baseValue * heightAspect)
  }
  
  override var image: UIImage? {
    didSet {
      invalidateIntrinsicContentSize()
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    invalidateIntrinsicContentSize()
  }
  
  private func gcd(_ lhs: Int, _ rhs: Int) -> Int {
    var x = lhs
    var y = rhs
    
    while y != 0 {
      let t = x % y
      x = y
      y = t
    }
    
    return x
  }
}
