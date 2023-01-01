import AppFeature
import Foundation
import UIKit

open class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    public final var window: UIWindow?

    public func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = MainViewController()
        self.window = window
        window.makeKeyAndVisible()
    }

    public final func sceneDidBecomeActive(_ scene: UIScene) {
    }

    public final func sceneWillResignActive(_ scene: UIScene) {
    }

    public final func sceneWillEnterForeground(_ scene: UIScene) {
    }

    public final func sceneDidEnterBackground(_ scene: UIScene) {
    }
}
