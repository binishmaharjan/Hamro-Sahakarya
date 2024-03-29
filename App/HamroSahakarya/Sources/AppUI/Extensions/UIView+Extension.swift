import UIKit

extension UIView {
    public enum Types {
        case cornerRadius(CGFloat)
        case borderWidth(CGFloat)
        case borderColor(UIColor)
    }
    
    public func apply(types: [Types]) {
        types.forEach { (type) in
            switch type {
            case .cornerRadius(let value):
                self.layer.cornerRadius = value
            case .borderWidth(let value):
                self.layer.borderWidth = value
            case .borderColor(let color):
                self.layer.borderColor = color.cgColor
            }
        }
    }
}


// MARK: View Shortcuts
public let DEF_SHADOW_COLOR = UIColor(red:0, green:0, blue:0, alpha:1)
public let DEF_SHADOW_OPACITY: Float = 0.1
public let DEF_SHADOW_OFFSET: CGSize = CGSize(width:0, height:2)
public let DEF_SHADOW_RADIUS: CGFloat = 4.0

extension UIView{
    public func applyGradient(colors: [CGColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = self.bounds
        self.layer.addSublayer(gradientLayer)
    }
}

extension UIView {
    public var x: CGFloat {
        get { return self.frame.origin.x }
        set(v) { self.frame.origin.x = v }
    }
    public var y: CGFloat {
        get { return self.frame.origin.y }
        set(v) { self.frame.origin.y = v }
    }
    public var width: CGFloat {
        get { return self.frame.size.width }
        set(v) { self.frame.size.width = v }
    }
    public var height: CGFloat {
        get { return self.frame.size.height }
        set(v) { self.frame.size.height = v }
    }
    public var right: CGFloat {
        get { return self.x + self.width }
        set(v) { self.x = v - self.width }
    }
    public var bottom: CGFloat {
        get { return self.y + self.height }
        set(v) { self.y = v - self.height }
    }
    public var o:CGPoint {
        get { return CGPoint(x:self.width / 2.0, y: self.height / 2.0) }
    }
    
    public var absoluteX: CGFloat {
        get {
            var v:UIView? = self
            var x:CGFloat = 0
            while v != nil {
                x += v!.x
                if v is UIScrollView { x -= (v as! UIScrollView).contentOffset.x }
                v = v!.superview
            }
            return x
        }
    }
    public var absoluteY: CGFloat {
        get {
            var v:UIView? = self
            var y:CGFloat = 0
            while v != nil {
                y += v!.y
                if v is UIScrollView { y -= (v as! UIScrollView).contentOffset.y }
                v = v!.superview
            }
            return y
        }
    }
    
    public var maskedCorners: CACornerMask {
        get{
            return self.layer.maskedCorners
        }
        set(value){
            self.layer.maskedCorners = value
        }
    }
    
    public func dropShadow(
        color:UIColor = DEF_SHADOW_COLOR
        ,opacity:Float = DEF_SHADOW_OPACITY
        ,offset:CGSize = DEF_SHADOW_OFFSET
        ,radius:CGFloat = DEF_SHADOW_RADIUS
    ) {
            self.layer.shadowColor = color.cgColor
            self.layer.shadowOpacity = opacity
            self.layer.shadowOffset = offset
            self.layer.shadowRadius = radius
            self.layer.shouldRasterize = true
            self.layer.rasterizationScale = UIScreen.main.scale
        }
    
    public func contain(gesture:UIGestureRecognizer) -> Bool {
        let p = gesture.location(in: self)
        return self.frame.contains(p)
    }
}

extension UIView{
    public func addBorder(name:String, frame:CGRect, color: UIColor) {
        if let sublayers = self.layer.sublayers {
            for layer in sublayers {
                if(layer.name == name){
                    layer.removeFromSuperlayer()
                }
            }
        }
        let border = CALayer()
        border.name = name
        border.frame = frame
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
    
    public func addBorderBottom(thickness: CGFloat, color: UIColor) {
        self.addBorder(name: "addBorderBottom", frame: CGRect(x: 0, y: self.frame.height - thickness, width: self.frame.width, height: thickness), color: color)
    }
    
    public func addBorderTop(thickness: CGFloat, color: UIColor) {
        self.addBorder(name: "addBorderTop", frame: CGRect(x: 0, y: 0, width: self.frame.width, height: thickness), color: color)
    }
    
    public func addBorderLeft(thickness: CGFloat, color: UIColor) {
        self.addBorder(name: "addBorderLeft", frame: CGRect(x: 0, y: 0, width: thickness, height: self.frame.height), color: color)
    }
    
    public func addBorderRight(thickness: CGFloat, color: UIColor) {
        self.addBorder(name: "addBorderRight", frame: CGRect(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height), color: color)
    }
    
    public var isDrawRectangle: Bool{
        get{
            return self.layer.borderWidth > 1
        }
        set(value){
            if(value){
                self.layer.borderColor = UIColor.red.cgColor
                self.layer.borderWidth = 1
            }
            else{
                self.layer.borderColor = UIColor.clear.cgColor
                self.layer.borderWidth = 0
            }
        }
    }
    
    public var isDrawUserInteractionEnabledRectangle: Bool {
        get{
            return isUserInteractionEnabled && self.layer.borderWidth > 1
        }
        set(value){
            if(value && isUserInteractionEnabled){
                self.layer.borderColor = UIColor.blue.cgColor
                self.layer.borderWidth = 1
            }
            else{
                self.layer.borderColor = UIColor.clear.cgColor
                self.layer.borderWidth = 0
            }
        }
    }
}

extension UIView {
    public func toImage(opaque:Bool = false) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, opaque, 0.0)
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        self.layer.render(in: ctx)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    public func toImageView() -> UIImageView {
        return UIImageView(image:self.toImage())
    }
    
    public func toPNG(opaque:Bool = false)->UIImage? {
        guard let image = self.toImage(opaque: opaque), let png = image.pngData() else { return nil }
        return UIImage(data: png)
    }
}
