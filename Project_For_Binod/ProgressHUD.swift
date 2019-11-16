//
//  ProgressHUD.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/11/15.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import RxSwift

class ProgressHUD: UIView {
  
  // MARK: IBOutlet
  @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet private weak var statusText: UILabel!
  
  // MARK: Properties
  var status: String = "Indicator" {
    didSet {
      statusText.text = status
    }
  }
  
  var isAnimating: Bool {
    return activityIndicator.isAnimating
  }
  
  // MARK: Instance
  static func makeInstance() -> ProgressHUD {
    let progressHud = ProgressHUD.loadXib()
    return progressHud
  }
  
  //MARK: Life Cycle
  override func awakeFromNib() {
    super.awakeFromNib()
    self.cornerRadius(value: 10)
  }
  
  // MARK: Methods
  func startAnimation() {
    activityIndicator.startAnimating()
  }
  
  func stopAnimation() {
    activityIndicator.stopAnimating()
  }
}

extension ProgressHUD: HasXib { }
