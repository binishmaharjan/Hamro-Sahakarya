//
//  HSHeaderView.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/04/14.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import TinyConstraints

class HSImageHeaderView:UICollectionReusableView{
  //MARK:Elements
  private weak var imageView:UIImageView?
  private weak var titleLabel:UILabel?
  private weak var titleBackground:UIView?
  var titleString:String?{
    didSet{
      self.titleLabel?.text = titleString
    }
  }
  
  //Animator
  var animator:UIViewPropertyAnimator!
  
  //MARK:Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setup()
    self.setupConstraints()
    self.setupVisualEffect()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK:Setup
  private func setup(){
    let imageView = UIImageView()
    self.imageView = imageView
    imageView.image = UIImage(named: "hamro_sahakarya")
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = true
    self.addSubview(imageView)
    
    let titleBackground = UIView()
    self.titleBackground = titleBackground
    self.addSubview(titleBackground)
    titleBackground.backgroundColor = HSColors.grey.withAlphaComponent(Constants.BACKGROUND_OPACITY)
    
    let titleLabel = UILabel()
    self.titleLabel = titleLabel
    titleBackground.addSubview(titleLabel)
    titleLabel.text = "Image Header"
    titleLabel.font = HSFont.heavy(size: 14)
    titleLabel.textColor = HSColors.orange
  }
  
  private func setupConstraints(){
    guard let imageView = self.imageView,
      let titleLabel = self.titleLabel,
      let titleBackground = self.titleBackground
      else {return}
    
    imageView.edgesToSuperview(excluding:.bottom)
    imageView.bottomToTop(of: titleBackground)
    
    titleBackground.bottomToSuperview()
    titleBackground.height(Constants.TITLE_HEIGHT)
    titleBackground.leftToSuperview()
    titleBackground.rightToSuperview()
    
    titleLabel.leftToSuperview(offset:Constants.TITLE_LEFT_MARGIN)
    titleLabel.bottomToSuperview()
  }
  
  //MARK: Visual Effects
  private func setupVisualEffect(){
    animator = UIViewPropertyAnimator(duration: Constants.ANIMATION_DUARTION, curve: .linear, animations: {[weak self] in
      //treat this area as the end state of your animation
      let blurEffect = UIBlurEffect(style: .regular)
      let visualEffect = UIVisualEffectView(effect: blurEffect)
      self?.imageView?.addSubview(visualEffect)
      visualEffect.edgesToSuperview()
    })
  }
}

//MARk:Constants
extension HSImageHeaderView{
  fileprivate class Constants{
    static let TITLE_LEFT_MARGIN:CGFloat = 10
    static let BACKGROUND_OPACITY:CGFloat = 0.5
    static let ANIMATION_DUARTION:Double = 3.0
    static let TITLE_HEIGHT:CGFloat = 26.0
  }
}

