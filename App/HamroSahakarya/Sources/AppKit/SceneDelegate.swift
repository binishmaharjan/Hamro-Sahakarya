import AppFeature
import Foundation
import UIKit

open class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    public final var window: UIWindow?
    private let injectionContainer = AppDependencyContainer()

    public func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }

        let window = UIWindow(windowScene: windowScene)
        let mainController = injectionContainer.makeMainViewController()
        window.rootViewController = mainController
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
