//
//  Array+Extension.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/04/04.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation

extension Array {
  
  /*
   安全な配列アクセスを提供する
   indexが範囲外の時、setterは無視し、getterはnilをか返す
   */
  subscript(optional index: Int) -> Element? {
    get {
      guard self.indices ~= index else {
        return nil
      }
      return self[index]
    }
    
    set {
      guard self.indices ~= index else {
        Dlog("WARN: index(\(index)) is out of range, so ignored. (array: \(self)")
        return
      }
      
      guard let newValue = newValue else {
        Dlog("WARN: new Value must not be nil value, so ignored. (array: \(self)")
        return
      }
      
      self[index] = newValue
    }
  }
  
  /*
   重複を取り除いた配列に変換する
   内部でNSOrderedSetを使うので元の配列の順序になることが保証される
   */
  func unique() -> [Element] {
    let orderSet = NSOrderedSet(array: self)
    return orderSet.array.compactMap { $0 as? Element }
  }
}
