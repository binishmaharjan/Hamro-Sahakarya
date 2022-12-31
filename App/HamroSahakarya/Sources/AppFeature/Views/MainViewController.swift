import UIKit
import AppUI


public final class MainViewController: UIViewController {

    private let progressHUD = XibProgressHUD.makeInstance()
    private let overlay = UIView()

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        startAnimation()
    }

    func startAnimation() {
      guard !progressHUD.isAnimating else {
        return
      }

      overlay.frame = view.frame
      overlay.backgroundColor = .mainBlack_30
      view.addSubview(overlay)

      view.addSubview(progressHUD)
      progressHUD.center = view.center
      progressHUD.startAnimation()
    }
}
