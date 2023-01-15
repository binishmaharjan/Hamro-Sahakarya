import AppUI
import UIKit

public final class TabBarController: UITabBarController {
    // MARK: Properties
    private let homeViewController: NibLessNavigationController
    private let logViewController: NibLessNavigationController
    private let profileViewController: NibLessNavigationController

    // MARK: Init
    public init(
        homeViewController: NibLessNavigationController,
        logViewController: NibLessNavigationController,
        profileViewController: NibLessNavigationController
    ) {
        self.homeViewController = homeViewController
        self.logViewController = logViewController
        self.profileViewController = profileViewController

        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [homeViewController, logViewController, profileViewController]
        setup()
    }

    // MARK: Methods
    private func setup() {
        let tabBar = UITabBar.appearance()
        tabBar.barTintColor = .white
        tabBar.tintColor = .orange

        tabBar.isTranslucent = false
        tabBar.backgroundColor = .white
        tabBar.shadowImage = UIImage()

        let tabBarItem = UITabBarItem.appearance()
        tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.gray], for: .normal)
        tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.orange], for: .selected)
        tabBarItem.titlePositionAdjustment = UIOffset(horizontal:0, vertical: 0)

        let shadowLayer = self.tabBar.layer
        shadowLayer.shadowOffset = CGSize(width: 0, height: 0)
        shadowLayer.shadowRadius = 1
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowOpacity = 0.1
    }
}
