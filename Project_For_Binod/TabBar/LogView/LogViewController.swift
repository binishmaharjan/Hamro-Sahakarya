//
//  LogViewController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/01/18.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit

final class LogViewController: UIViewController {
  
  init() {
    super.init(nibName: nil, bundle: nil)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .blue
  }
  
  private func setup() {
    title = nil
    tabBarItem.image = UIImage(named: "icon_log")?.withRenderingMode(.alwaysOriginal)
    tabBarItem.selectedImage = UIImage(named: "icon_log_h")?.withRenderingMode(.alwaysOriginal)
    tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
  }
}
