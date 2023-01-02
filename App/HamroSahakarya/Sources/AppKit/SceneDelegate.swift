import AppFeature
import Firebase
import Foundation
import UIKit

open class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    public final var window: UIWindow?
    private let injectionContainer = AppDependencyContainer()

    public func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }

//        setupFirebaseServer()

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

extension SceneDelegate {
    private func setupFirebaseServer(){
      var firebasePlistName = ""

//      if IS_DEBUG {
        firebasePlistName = "GoogleService-Info-dev"
//      } else {
//        firebasePlistName = "GoogleService-Info"
//      }
      if let path = Bundle.main.path(forResource: firebasePlistName, ofType: "plist"), let firebaseOptions = FirebaseOptions(contentsOfFile: path) {
        FirebaseApp.configure(options: firebaseOptions)
      }

      //Setup Session user
      self.setupSessionUser()
    }

    private func setupSessionUser(){
  //    guard let uid = HSSessionManager.shared.uid
  //      else {
  //        Dlog("NO USER LOGGED IN")
  //        return
  //    }
  //      HSSessionManager.shared.userLoggedIn(uid: uid)
    }
}
