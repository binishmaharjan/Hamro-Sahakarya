import UIKit

public class BaseView: UIView {
    // MARK: Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        didInit()
    }

    public convenience init() {
        self.init(frame: .zero)
        didInit()
    }

    // MARK: Common Init
    public func didInit() { }
}

extension BaseView: HasXib {}
