//
//  HSStretchyHeaderLayout.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/04/14.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit


class HSStretchyHeaderLayout:UICollectionViewFlowLayout{
  //MARK:Init
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    let layoutAttributes = super.layoutAttributesForElements(in: rect)
    
    //Getting First Header: i.e Image Header
    layoutAttributes?.forEach({ (attributes) in
      if attributes.representedElementKind == UICollectionView.elementKindSectionHeader &&
        attributes.indexPath.section == 0 {
        guard let collectionView = collectionView else {return}
        let width = collectionView.frame.width
        let contentOffsetY = collectionView.contentOffset.y
        if contentOffsetY > 0 { return }
        let height = attributes.frame.height - contentOffsetY
        attributes.frame = CGRect(x: 0, y: contentOffsetY, width: width, height: height)
      }
    })
    return layoutAttributes
  }
  
  //Refreshing Changes Everytime
  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }
}
