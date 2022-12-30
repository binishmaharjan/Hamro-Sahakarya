import Foundation
import UIKit

open class AppDelegate: NSObject, UIApplicationDelegate {

    public override init() {
        // Initializer
    }

    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        true
    }
}

//import AppFeature
//
//public final class AppDelegate: NSObject, UIApplicationDelegate {
//    private var store: StoreOf<AppReducer>?
//    func store(for primitiveEnvironment: PrimitiveEnvironment) -> StoreOf<AppReducer> {
//        if let store = store {
//            return store
//        }
//        let store = Store(primitiveEnvironment: primitiveEnvironment)
//        self.store = store
//        return store
//    }
//}
//
//public protocol App: SwiftUI.App {
//    var primitiveEnvironment: PrimitiveEnvironment { get }
//    var appDelegate: AppDelegate { get }
//}
//
//extension App {
//    public var body: some Scene {
//        WindowGroup {
//            RootView(store: appDelegate.store(for: primitiveEnvironment))
//        }
//    }
//}
//
