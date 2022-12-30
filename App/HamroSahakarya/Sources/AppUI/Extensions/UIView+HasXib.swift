import UIKit

public protocol HasXib { }

extension HasXib where Self: UIView {
    public static var xibName: String {
        return String(describing: Self.self)
    }
    
    public static func loadXib() -> Self {
        let nib = UINib(nibName: xibName, bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil).first as! Self
        return view
    }
}
