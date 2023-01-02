import Core
import UIKit

extension UITableView {
    public func registerXib<T: UITableViewCell>(of cellClass: T.Type, bundle: Bundle) {
        let className = cellClass.className
        let nib: UINib? = UINib(nibName: className, bundle: bundle)
        register(nib, forCellReuseIdentifier: className)
    }

    public func dequeueCell<T: UITableViewCell>(of cellClass: T.Type, for indexPath: IndexPath) -> T {
        let className = cellClass.className
        guard let cell = dequeueReusableCell(withIdentifier: className, for: indexPath) as? T else {
            fatalError()
        }

        return cell
    }
}

// MARK: Collection View
extension UICollectionView {
    public func registerXib<T: UICollectionViewCell>(of cellClass: T.Type, bundle: Bundle) {
        let className = cellClass.className
        let nib: UINib? = UINib(nibName: className, bundle: Bundle(for: cellClass))
        register(nib, forCellWithReuseIdentifier: className)
    }

    public func dequeueCell<T: UICollectionViewCell>(of cellClass: T.Type, for indexPath: IndexPath) -> T {
        let className = cellClass.className
        guard let cell = dequeueReusableCell(withReuseIdentifier: className, for: indexPath) as? T else {
            fatalError()
        }

        return cell
    }
}
