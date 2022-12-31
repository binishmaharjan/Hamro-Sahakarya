//
//  GUIManager.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/11/23.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import RxSwift

final class GUIManager: NSObject {
  
  // MARK: Properties
  private let mainView = appDelegate.window
   private let progressHUD = XibProgressHUD.makeInstance()
   private let overlay = UIView()
  
  // MARK: Init(Singleton)
  static var shared = GUIManager()
  private override init() { }
  
  // MARK: - Activity Indicator
  /// Start the activity indicator in window
  ///
  /// - Parameter None
  /// - Return: Void
  func startAnimation() {
    guard let mainView = mainView else {
      fatalError("No uiwindow")
    }
    
    guard !progressHUD.isAnimating else {
      return
    }
    
    overlay.frame = mainView.frame
    overlay.backgroundColor = .mainBlack_30
    mainView.addSubview(overlay)
    
    mainView.addSubview(progressHUD)
    progressHUD.center = mainView.center
    progressHUD.startAnimation()
  }
  
  /// Stop the activity indicator if its is running
  ///
  /// - Parameter None
  /// - Return: Void
  func stopAnimation() {
    guard progressHUD.isAnimating else { return }
    
      overlay.removeFromSuperview()
      
      progressHUD.stopAnimation()
      progressHUD.removeFromSuperview()
  }
  
  // MARK: - Drop Down Animtaion
  /// Start the drop down animations in specified view
  ///
  /// - Parameter dropDownModel: Data to populate the Drop Down Notifiacation
  /// - Return: Void
  func showDropDownNotification(data dropDownModel: DropDownModel) {
    guard let mainView = mainView else {
      fatalError("No uiwindow")
    }
    
    let dropDown = SimpleDropDownNotification()
    dropDown.text = dropDownModel.message
    dropDown.type = dropDownModel.dropDownType
    mainView.addSubview(dropDown)
    dropDown.startDropDown()
  }
  
  //MARK: - Alert Dialog
  /// Show Alert Dialog
  ///
  /// - Parameter message: Display message for alert
  /// - Parameter completionHandler: Action when ok action button is pressed
  func showDialog(factory: AlertFactory, completionHandler: (() -> Void)? = nil) {
     guard let mainView = mainView else {
      fatalError("No uiwindow")
    }
    
    let alertDialog = AlertDialog.makeInstance(factory: factory, handler: completionHandler)
    alertDialog.alpha = 0
    mainView.addSubview(alertDialog)
    alertDialog.frame = mainView.frame
    
    UIView.animate(withDuration: 0.3) {
      alertDialog.alpha = 1
    }
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

