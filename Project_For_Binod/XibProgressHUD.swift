//
//  ProgressHUD.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/11/15.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import RxSwift

protocol ProgressHUD {
  func startAnimation()
  func stopAnimation()
}

typealias XibProgressHUDType = UIView & ProgressHUD

final class XibProgressHUD: XibProgressHUDType {
  
  // MARK: IBOutlet
  @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet private weak var statusText: UILabel!
  
  // MARK: Properties  
  var isAnimating: Bool {
    return activityIndicator.isAnimating
  }
  
  // MARK: Instance
  static func makeInstance() -> XibProgressHUD {
    let progressHud = XibProgressHUD.loadXib()
    return progressHud
  }
  
  //MARK: Life Cycle
  override func awakeFromNib() {
    super.awakeFromNib()
    self.apply(types: [.cornerRadius(10)])
  }
  
  // MARK: Methods
  func startAnimation() {
    activityIndicator.startAnimating()
  }
  
  func stopAnimation() {
    activityIndicator.stopAnimating()
  }
}

extension XibProgressHUD: HasXib { }
