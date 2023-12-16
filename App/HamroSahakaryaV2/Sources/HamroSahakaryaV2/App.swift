import SwiftUI

public protocol App: SwiftUI.App {
    var appDelegate: AppDelegate { get }
}

extension App {
    public var body: some Scene {
        WindowGroup {
            Text("Hello World SwiftUI")
        }
    }
}
