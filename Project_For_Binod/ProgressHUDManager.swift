//
//  ProgressHUDManager.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/11/15.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ProgressHUDManager: NSObject {
  
  // MARK: Properties
  private let progressHUD = ProgressHUD.makeInstance()
  private let overlay = UIView()
  
  // MARK: Init(Singleton)
  static var shared = ProgressHUDManager()
  private override init() { }
  
  // MARK: Methods
  func startAnimation(view: UIView) {
    if !progressHUD.isAnimating {
      
      overlay.frame = view.frame
      overlay.backgroundColor = UIColor.black.withAlphaComponent(0.3)
      view.addSubview(overlay)
      
      view.addSubview(progressHUD)
      progressHUD.center = view.center
      progressHUD.startAnimation()
    }
  }
  
  func stopAnimation() {
    if progressHUD.isAnimating {
      
      overlay.removeFromSuperview()
      
      progressHUD.stopAnimation()
      progressHUD.removeFromSuperview()
    }
  }
}

// MARK: Reactive Extension
extension Reactive where Base: ProgressHUDManager {
  static func isAnimating(view: UIView) -> AnyObserver<Bool> {
    return AnyObserver { event in
      switch event {
      case .next(let value):
        if value {
          ProgressHUDManager.shared.startAnimation(view: view)
        } else {
          ProgressHUDManager.shared.stopAnimation()
        }
      default:
        break
      }
    }
  }
}
