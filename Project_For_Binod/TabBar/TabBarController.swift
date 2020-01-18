//
//  TabBarController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/01/18.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit

final class TabBarController: UITabBarController {
  
  // MARK: Properties
  private let homeViewController: UIViewController
  private let logViewController: UIViewController
  private let profileViewController: UIViewController
  
  // MARK: Init
  init(homeViewController: UIViewController, logViewController: UIViewController, profileViewController: UIViewController) {
    self.homeViewController = homeViewController
    self.logViewController = logViewController
    self.profileViewController = profileViewController
  
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    viewControllers = [homeViewController, logViewController, profileViewController]
    setup()
  }
  
  // MARK: Methods
  private func setup() {
    let tabBar = UITabBar.appearance()
    tabBar.barTintColor = .white
    tabBar.tintColor = .orange
    
    tabBar.isTranslucent = false
    tabBar.backgroundColor = .white
    tabBar.shadowImage = UIImage()
    
    let tabBarItem = UITabBarItem.appearance()
    tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.gray], for: .normal)
    tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.orange], for: .selected)
    tabBarItem.titlePositionAdjustment = UIOffset(horizontal:0, vertical: 0)
    
    let shadowLayer = self.tabBar.layer
    shadowLayer.shadowOffset = CGSize(width: 0, height: 0)
    shadowLayer.shadowRadius = 1
    shadowLayer.shadowColor = UIColor.black.cgColor
    shadowLayer.shadowOpacity = 0.1
  }
}
