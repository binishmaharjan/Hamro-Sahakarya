import UIKit

public protocol HasXib { }

extension HasXib where Self: UIView {
    public static var xibName: String {
        return String(describing: Self.self)
    }
    
    public static func loadXib(bundle: Bundle) -> Self {
        let nib = UINib(nibName: xibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! Self
        return view
    }
}
