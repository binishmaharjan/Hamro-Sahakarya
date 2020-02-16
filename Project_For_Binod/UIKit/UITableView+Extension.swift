//
//  UITableView+Extension.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/01/20.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit

extension UITableView {
  
  func registerXib<T:UITableViewCell>(of cellClass: T.Type) {
    let className = cellClass.className
    let nib: UINib? = UINib(nibName: className, bundle: Bundle(for: cellClass))
    register(nib, forCellReuseIdentifier: className)
  }
  
  func dequeueCell<T:UITableViewCell>(of cellClass: T.Type, for indexPath: IndexPath) -> T {
    let className = cellClass.className
    guard let cell = dequeueReusableCell(withIdentifier: className, for: indexPath) as? T else {
      fatalError()
    }
    
    return cell
  }
}

// MARK: Collection View
extension UICollectionView {
  
  func registerXib<T:UICollectionViewCell>(of cellClass: T.Type) {
    let className = cellClass.className
    let nib: UINib? = UINib(nibName: className, bundle: Bundle(for: cellClass))
    register(nib, forCellWithReuseIdentifier: className)
  }
  
  func dequeueCell<T:UICollectionViewCell>(of cellClass: T.Type, for indexPath: IndexPath) -> T {
    let className = cellClass.className
    guard let cell = dequeueReusableCell(withReuseIdentifier: className, for: indexPath) as? T else {
      fatalError()
    }
    
    return cell
  }
}
