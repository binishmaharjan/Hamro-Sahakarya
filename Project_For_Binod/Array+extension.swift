//
//  Array+extesnion.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/03/22.
//  Copyright © 2019 JEC. All rights reserved.
//

import Foundation
import UIKit


extension Array{
  
  subscript (safe index: Int) -> Element? {
    return index >= 0 && index < self.count ? self[index] : nil
  }
  
  var cgPoint:CGPoint{
    let x = CGFloat(truncating: self[safe: 0] as? NSNumber ?? 0)
    let y = CGFloat(truncating: self[safe: 1] as? NSNumber ?? 0)
    return CGPoint(x: x, y: y)
  }
  
  var cgVector:CGVector {
    let x = CGFloat(truncating: self[safe: 0] as? NSNumber ?? 0)
    let y = CGFloat(truncating: self[safe: 1] as? NSNumber ?? 0)
    return CGVector(dx: x, dy: y)
  }
  
  var cgSize:CGSize{
    let w = CGFloat(truncating: self[safe: 0] as? NSNumber ?? 0)
    let h = CGFloat(truncating: self[safe: 1] as? NSNumber ?? 0)
    return CGSize(width: w, height: h)
  }
  
  var cgRect:CGRect{
    let x = CGFloat(truncating: self[safe: 0] as? NSNumber ?? 0)
    let y = CGFloat(truncating: self[safe: 1] as? NSNumber ?? 0)
    let w = CGFloat(truncating: self[safe: 2] as? NSNumber ?? 0)
    let h = CGFloat(truncating: self[safe: 3] as? NSNumber ?? 0)
    return CGRect(x: x, y: y, width: w, height: h)
  }
  
  var cgAffineTransform:CGAffineTransform{
    let a = CGFloat(truncating: self[safe: 0] as? NSNumber ?? 0)
    let b = CGFloat(truncating: self[safe: 1] as? NSNumber ?? 0)
    let c = CGFloat(truncating: self[safe: 2] as? NSNumber ?? 0)
    let d = CGFloat(truncating: self[safe: 3] as? NSNumber ?? 0)
    let tx = CGFloat(truncating: self[safe: 4] as? NSNumber ?? 0)
    let ty = CGFloat(truncating: self[safe: 5] as? NSNumber ?? 0)
    return CGAffineTransform(a: a, b: b, c: c, d: d, tx: tx, ty: ty)
  }
  
  var uiEdgeInsets:UIEdgeInsets{
    let top = CGFloat(truncating: self[safe: 0] as? NSNumber ?? 0)
    let left = CGFloat(truncating: self[safe: 1] as? NSNumber ?? 0)
    let bottom = CGFloat(truncating: self[safe: 2] as? NSNumber ?? 0)
    let right = CGFloat(truncating: self[safe: 3] as? NSNumber ?? 0)
    return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
  }
  
  var uiOffset:UIOffset{
    let horizontal = CGFloat(truncating: self[safe: 0] as? NSNumber ?? 0)
    let vertical = CGFloat(truncating: self[safe: 1] as? NSNumber ?? 0)
    return UIOffset(horizontal: horizontal, vertical: vertical)
  }
  
  var rangeFloat:Range<CGFloat>{
    let lower = CGFloat(truncating: self[safe: 0] as? NSNumber ?? 0)
    let upper = CGFloat(truncating: self[safe: 1] as? NSNumber ?? 0)
    return Range.init(uncheckedBounds: (lower: lower, upper: upper))
  }
  var rangeInt:Range<Int>{
    let lower = Int(truncating: self[safe: 0] as? NSNumber ?? 0)
    let upper = Int(truncating: self[safe: 1] as? NSNumber ?? 0)
    return Range.init(uncheckedBounds: (lower: lower, upper: upper))
  }
  
  var uiColor:UIColor{
    let r = CGFloat(truncating: self[safe: 0] as? NSNumber ?? 0)
    let g = CGFloat(truncating: self[safe: 1] as? NSNumber ?? 0)
    let b = CGFloat(truncating: self[safe: 2] as? NSNumber ?? 0)
    let a = CGFloat(truncating: self[safe: 3] as? NSNumber ?? 1)
    return UIColor(red: r/255, green: g/255, blue: b/255, alpha: a)
  }
}

extension Array where Element: Equatable {
  var unique: [Element] {
    return reduce([Element](), { (result, sequence) in
      result.contains(sequence) ? result : result + [sequence]
    })
  }
}
