//
//  PhotoCell.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/02/05.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit

final class PhotoCell: UICollectionViewCell {

  @IBOutlet weak var photoView: UIImageView!
  
  override func prepareForReuse() {
    super.prepareForReuse()
    photoView.image = nil
  }
  
  func bind(viewModel: PhotoCellViewModel) {
    photoView.image = viewModel.image
  }

}

extension PhotoCell {
  
  func flash() {
    photoView.alpha = 0
    setNeedsDisplay()
    
    UIView.animate(withDuration: 0.5) { [weak self] in
      self?.photoView.alpha = 1
    }
  }
}

protocol PhotoCellViewModel {
  var image: UIImage? { get }
}

struct DefaultPhotoCellViewModel: PhotoCellViewModel {
  let image: UIImage?
}
