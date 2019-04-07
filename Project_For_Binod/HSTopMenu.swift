//
//  HSTopMenu.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/04/06.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import TinyConstraints

class HSTopMenu:HSBaseView{
  //MARK:ELEments
  private weak var collectionView:UICollectionView?
  private weak var bar:UIView?
  private var barLeftConstraints:Constraint?
  weak var homePager:HSHomePagerController?
  
  typealias CELL1 = HSTopMenuCell
  let CELL1_CLASS = CELL1.self
  let CELL1_ID = NSStringFromClass(CELL1.self)
  
  private let items:[String] = ["Group","Member"]
  
  //MARK:Init
  override func didInit() {
    super.didInit()
    self.setup()
    self.seutupConstraints()
  }
  
  //MARk:Setup
  private func setup(){
    //collection view
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    self.collectionView = collectionView
    collectionView.backgroundColor = HSColors.white
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.register(CELL1_CLASS, forCellWithReuseIdentifier: CELL1_ID)
    self.addSubview(collectionView)
    
    //bar
    let bar = UIView()
    self.bar = bar
    bar.backgroundColor = UIColor.orange
    self.addSubview(bar)
  }
  
  private func seutupConstraints(){
    guard let collectionView = self.collectionView,
          let bar = self.bar
      else {return}
    
    collectionView.edgesToSuperview()
    
    barLeftConstraints = bar.leftToSuperview()
    bar.bottomToSuperview()
    bar.width(UIScreen.main.bounds.width / 2)
    bar.height(3)
  }
}

//MARK:Delegate & Datasource
extension HSTopMenu:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL1_ID, for: indexPath) as? HSTopMenuCell{
      cell.setTitle(title: items[indexPath.row])
      return cell
    }
    return UICollectionViewCell()
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: frame.width / 2, height: frame.height)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    barLeftConstraints?.constant = (UIScreen.main.bounds.width / 2) * CGFloat(indexPath.row)
    UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
      self.layoutIfNeeded()
    }, completion: nil)
    self.topMenuItemWasPress(index: indexPath.row)
  }
}

//MARK: Changes in the Bar / Current Page
extension HSTopMenu{
  func pagerViewScrollChanged(offsetX:CGFloat){
    self.barLeftConstraints?.constant = offsetX
  }
  
  private func topMenuItemWasPress(index:Int){
    guard let homePager = self.homePager else {return}
    homePager.topMenuItemWasPressed(index: index)
  }
}
