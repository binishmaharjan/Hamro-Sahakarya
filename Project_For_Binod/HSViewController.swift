//
//  HSViewController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/03/22.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import TinyConstraints

class HSViewController:UIViewController{
  var isNib:Bool = false
  var statusBarStyle:UIStatusBarStyle = .default
  
  weak var outsideSafeAreaTopViewTemp:UIView?
  weak var outsideSafeAreaBottomViewTemp:UIView?
  
  init() {
    super.init(nibName: nil, bundle: nil)
    didInit()
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nil)
    didInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    didInit()
  }
  
  func didInit(){
    self.setup()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = HSColors.white
    self.navigationController?.setNavigationBarHidden(true, animated: false)

  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }

  private func setup(){
    let insideSafeAreaView = UIView()
    insideSafeAreaView.isUserInteractionEnabled = false
    self.view.addSubview(insideSafeAreaView)
    self.setupMainViewConstraints(insideSafeAreaView)
    
    let outsideSafeAreaTopViewTemp = UIView()
    outsideSafeAreaTopViewTemp.isUserInteractionEnabled = false
    self.view.addSubview(outsideSafeAreaTopViewTemp)
    self.outsideSafeAreaTopViewTemp = outsideSafeAreaTopViewTemp
    
    let outsideSafeAreaBottomViewTemp = UIView()
    outsideSafeAreaBottomViewTemp.isUserInteractionEnabled = false
    self.view.addSubview(outsideSafeAreaBottomViewTemp)
    self.outsideSafeAreaBottomViewTemp = outsideSafeAreaBottomViewTemp
    
    outsideSafeAreaTopViewTemp.edgesToSuperview(excluding: .bottom)
    outsideSafeAreaTopViewTemp.bottomToTop(of: insideSafeAreaView)
    
    outsideSafeAreaBottomViewTemp.topToBottom(of: insideSafeAreaView)
    outsideSafeAreaBottomViewTemp.edgesToSuperview(excluding: .top)
    
    insideSafeAreaView.superview?.sendSubviewToBack(insideSafeAreaView)
    outsideSafeAreaBottomViewTemp.superview?.sendSubviewToBack(outsideSafeAreaBottomViewTemp)
    outsideSafeAreaTopViewTemp.superview?.sendSubviewToBack(outsideSafeAreaTopViewTemp)
  }
  
  func setupMainViewConstraints(_ mainView:UIView){
    mainView.edgesToSuperview(usingSafeArea:true)
  }
}
