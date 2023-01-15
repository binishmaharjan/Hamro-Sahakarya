import UIKit

public final class MainOrangeButton: UIButton {
    public override var isEnabled: Bool {
    didSet {
      backgroundColor = self.isEnabled ? .mainOrange : .mainOrange_70
    }
  }
}
