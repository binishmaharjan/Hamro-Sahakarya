import AppUI
import Core
import UIKit


public final class MainViewController: UIViewController {

    private let progressHUD = XibProgressHUD.makeInstance()
    private let overlay = UIView()

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        GUIManager.shared.showDialog(factory: .logoutConfirmation)
    }
}
