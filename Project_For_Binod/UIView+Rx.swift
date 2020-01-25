//
//  UIViewController+Rx.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/01/20.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit
import RxSwift

extension Reactive where Base: UIView {
  
  var onLayoutSubViewsTrigger: Observable<Void> {
    return sentMessage(#selector(base.layoutSubviews)).map { _ in }.share(replay: 1, scope: .forever)
  }
  
  var onLayoutSubviewsInvoked: Observable<Void> {
    return methodInvoked(#selector(base.layoutSubviews)).map { _ in }.share(replay: 1, scope: .forever)
  }
}
