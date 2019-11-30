//
//  GUIManager.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/11/23.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import RxSwift

class GUIManager: NSObject {
  
  // MARK: Properties
  private let mainView = appDelegate.window
   private let progressHUD = XibProgressHUD.makeInstance()
   private let overlay = UIView()
  
  // MARK: Init(Singleton)
  static var shared = GUIManager()
  private override init() { }
  
  // MARK: - Activity Indicator
  /// Start the activity indicator in window
  func startAnimation() {
    guard let mainView = mainView else { fatalError("No uiwindow") }
    guard !progressHUD.isAnimating else { return }
    
    overlay.frame = mainView.frame
    overlay.backgroundColor = .mainBlack_30
    mainView.addSubview(overlay)
    
    mainView.addSubview(progressHUD)
    progressHUD.center = mainView.center
    progressHUD.startAnimation()
  }
  
  /// Stop the activity indicator if its is running
  func stopAnimation() {
    guard progressHUD.isAnimating else { return }
    
      overlay.removeFromSuperview()
      
      progressHUD.stopAnimation()
      progressHUD.removeFromSuperview()
  }
  
  // MARK: - Drop Down Animtaion
  /// Start the drop down animations in specified view
  func showDropDownNotification(data dropDownModel: DropDownModel) {
    guard let mainView = mainView else { fatalError("No uiwindow") }
    
    let dropDown = SimpleDropDownNotification()
    dropDown.text = dropDownModel.message
    dropDown.type = dropDownModel.dropDownType
    mainView.addSubview(dropDown)
    dropDown.startDropDown()
  }
  
}

// MARK: Reactive Extensions - Activity Indicator
extension Reactive where Base: GUIManager {
  /// AnyObservable for binding the activity indicator
  static func isIndicatorAnimating() -> AnyObserver<Bool> {
    return AnyObserver { event in
      switch event {
      case .next(let value):
        if value {
          GUIManager.shared.startAnimation()
        } else {
          GUIManager.shared.stopAnimation()
        }
      default:
        break
      }
    }
  }
}

// MARK: Reactive Extensions - Drop Down Notification
extension Reactive where Base: GUIManager {
  //AnyObservable for binding the dropDownNotification
  static func shouldShowDropDown() -> AnyObserver<DropDownModel> {
    return AnyObserver { event in
      switch event {
      case .next(let value):
        GUIManager.shared.showDropDownNotification(data: value)
      default:
        break
      }
    }
  }
}

