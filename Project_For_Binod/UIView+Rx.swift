//
//  UIViewController+Rx.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/01/20.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit
import RxSwift

extension Reactive where Base: UIViewController {
  
  var onLayoutSubViewsTrigger: Observable<Void> {
    return sentMessage(#selector(base.layou))
  }
}
