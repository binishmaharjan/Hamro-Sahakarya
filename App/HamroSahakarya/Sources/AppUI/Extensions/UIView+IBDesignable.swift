import UIKit

@IBDesignable
extension UIView {
    @IBInspectable
    public var borderWidth: CGFloat {
        set {
            self.layer.borderWidth = newValue
        }
        get {
            return self.borderWidth
        }
    }

    @IBInspectable
    public var borderColor: UIColor {
        set {
            self.layer.borderColor = newValue.cgColor
        }
        get {
            return self.borderColor
        }
    }

    @IBInspectable
    public var cornerRadius: CGFloat {
        set {
            self.layer.cornerRadius = newValue
        }
        get {
            return self.cornerRadius
        }
    }
}

