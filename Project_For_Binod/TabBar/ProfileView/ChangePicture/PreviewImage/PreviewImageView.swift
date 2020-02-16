//
//  PreviewImageView.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/02/08.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit

final class PreviewImageView: UIView {
  
  @IBOutlet private weak var imageView: UIImageView!
  @IBOutlet private weak var imageViewBottomConstraints: NSLayoutConstraint!
  @IBOutlet private weak var imageViewTopConstraints: NSLayoutConstraint!
  @IBOutlet private weak var imageViewLeadingConstraints: NSLayoutConstraint!
  @IBOutlet private weak var imageViewTrailingConstraints: NSLayoutConstraint!
  @IBOutlet private weak var scrollView: UIScrollView!
  
  override func layoutSubviews() {
    super.layoutSubviews()
    updateMinZoomScaleForSize(self.bounds.size)
  }
  
  func setImage(image: UIImage?) {
    self.imageView.image = image
    setNeedsLayout()
    layoutIfNeeded()
  }
}

extension PreviewImageView: UIScrollViewDelegate {
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageView
  }
  
  func scrollViewDidZoom(_ scrollView: UIScrollView) {
    updateConstraintsForSize(self.bounds.size)
  }
  
  private func updateMinZoomScaleForSize(_ size: CGSize) {
    let widthScale = size.width / imageView.bounds.width
    let heightScale = size.height / imageView.bounds.height
    let minScale = min(widthScale, heightScale)
      
    scrollView.minimumZoomScale = minScale
    scrollView.zoomScale = minScale
  }

  func updateConstraintsForSize(_ size: CGSize) {
    let yOffset = max(0, (size.height - imageView.frame.height) / 2)
    imageViewTopConstraints.constant = yOffset
    imageViewBottomConstraints.constant = yOffset
    
    let xOffset = max(0, (size.width - imageView.frame.width) / 2)
    imageViewLeadingConstraints.constant = xOffset
    imageViewTrailingConstraints.constant = xOffset
      
    self.layoutIfNeeded()
  }
}

extension PreviewImageView: HasXib {
  
  static func makeInstance(with image: UIImage?) -> PreviewImageView {
    let previewImageView = PreviewImageView.loadXib()
    previewImageView.imageView.image = image
    previewImageView.scrollView.delegate = previewImageView
    return previewImageView
  }
}
