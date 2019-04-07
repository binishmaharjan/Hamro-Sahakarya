//
//  HSTabViewController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/04/02.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import TinyConstraints
import FirebaseAuth


class HSTabBarController:UITabBarController{
  
  private var authHandler:AuthStateDidChangeListenerHandle?
  
  
  //MARK:Overrides
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupTabBar()
    
    let homeView = HSHomeViewController()
    let homeNav = HSNavigationController(rootViewController:homeView)
    homeView.view.backgroundColor = HSColors.white
    homeView.title = nil
    homeView.tabBarItem.image = UIImage(named: "icon_home")?.withRenderingMode(.alwaysOriginal)
    homeView.tabBarItem.selectedImage = UIImage(named: "icon_home_h")?.withRenderingMode(.alwaysOriginal)
    homeView.tabBarItem.imageInsets = Constants.TAB_BAR_ITEM_EDGE_INSETS
    
    let view2 = UIViewController()
    view2.view.backgroundColor = HSColors.white
    view2.title = nil
    view2.tabBarItem.image = UIImage(named: "icon_log")?.withRenderingMode(.alwaysOriginal)
    view2.tabBarItem.selectedImage = UIImage(named: "icon_log_h")?.withRenderingMode(.alwaysOriginal)
    view2.tabBarItem.imageInsets = Constants.TAB_BAR_ITEM_EDGE_INSETS
    
    let view3 = UIViewController()
    view3.view.backgroundColor = HSColors.white
    view3.title = nil
    view3.tabBarItem.image = UIImage(named: "icon_profile")?.withRenderingMode(.alwaysOriginal)
    view3.tabBarItem.selectedImage = UIImage(named: "icon_profile_h")?.withRenderingMode(.alwaysOriginal)
    view3.tabBarItem.imageInsets = Constants.TAB_BAR_ITEM_EDGE_INSETS
    
    self.viewControllers = [homeNav,view2,view3]
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    authHandler = Auth.auth().addStateDidChangeListener({ (auth, user) in
      if user == nil{
        let loginVC = HSLoginViewController()
        self.present(loginVC, animated: true, completion: nil)
      }else{
        
      }
    })
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
  }
  
  
  //MARK:TabBar Setup
  private func setupTabBar(){
    
    let tabBar = UITabBar.appearance()
    tabBar.barTintColor = HSColors.white
    tabBar.tintColor = HSColors.orange
    
    tabBar.isTranslucent = false
    tabBar.backgroundColor = HSColors.white
    tabBar.shadowImage = UIImage()
    
    let tabBarItem = UITabBarItem.appearance()
    tabBarItem.setTitleTextAttributes([.foregroundColor: HSColors.grey], for: .normal)
    tabBarItem.setTitleTextAttributes([.foregroundColor: HSColors.orange], for: .selected)
    tabBarItem.titlePositionAdjustment = UIOffset(horizontal: Constants.ZER0, vertical: Constants.ZER0)
    
    let shadowLayer = self.tabBar.layer
    shadowLayer.shadowOffset = Constants.TAB_BAR_SHADOW_OFFSET
    shadowLayer.shadowRadius = Constants.TAB_BAR_SHADOW_RADIUS
    shadowLayer.shadowColor = UIColor.black.cgColor
    shadowLayer.shadowOpacity = Constants.TAB_BAR_SHADOW_OPACITY

  }
}

//MARK:Constants
extension HSTabBarController{
  fileprivate class Constants{
    static let TAB_ITEM_HOR_MAR:CGFloat = 0
    static let TAB_ITEM_VER_MAR:CGFloat = 6
    static let TAB_BAR_SHADOW_OPACITY:Float = 0.1
    static let TAB_BAR_SHADOW_RADIUS:CGFloat = 1
    static let TAB_BAR_SHADOW_OFFSET:CGSize = CGSize(width: 0, height: 0)
    static let TAB_BAR_ITEM_EDGE_INSETS:UIEdgeInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
    static let ZER0:CGFloat = 0
  }
}