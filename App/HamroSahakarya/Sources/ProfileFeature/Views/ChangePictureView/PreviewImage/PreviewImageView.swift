import AppUI
import UIKit

public final class PreviewImageView: UIView {
    // MARK: IBOutlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var imageViewBottomConstraints: NSLayoutConstraint!
    @IBOutlet private weak var imageViewTopConstraints: NSLayoutConstraint!
    @IBOutlet private weak var imageViewLeadingConstraints: NSLayoutConstraint!
    @IBOutlet private weak var imageViewTrailingConstraints: NSLayoutConstraint!
    @IBOutlet private weak var scrollView: UIScrollView!

    public override func layoutSubviews() {
        super.layoutSubviews()
        updateMinZoomScaleForSize(self.bounds.size)
    }

    public func setImage(image: UIImage?) {
        self.imageView.image = image
        setNeedsLayout()
        layoutIfNeeded()
    }
}

extension PreviewImageView: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize(self.bounds.size)
    }

    private func updateMinZoomScaleForSize(_ size: CGSize) {
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)

        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
    }

    private func updateConstraintsForSize(_ size: CGSize) {
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
    public static func makeInstance(with image: UIImage?) -> PreviewImageView {
        let previewImageView = PreviewImageView.loadXib()
        previewImageView.imageView.image = image
        previewImageView.scrollView.delegate = previewImageView
        return previewImageView
    }
}
