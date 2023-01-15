import UIKit

public final class PhotoCell: UICollectionViewCell {

    @IBOutlet weak var photoView: UIImageView!

    public override func prepareForReuse() {
        super.prepareForReuse()
        photoView.image = nil
    }

    public func bind(viewModel: PhotoCellViewModel) {
        photoView.image = viewModel.image
    }
}

extension PhotoCell {
    public func flash() {
        photoView.alpha = 0
        setNeedsDisplay()

        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.photoView.alpha = 1
        }
    }
}

// MARK: ViewModel
public protocol PhotoCellViewModel {
    var image: UIImage? { get }
}

public struct DefaultPhotoCellViewModel: PhotoCellViewModel {
    public let image: UIImage?
}
