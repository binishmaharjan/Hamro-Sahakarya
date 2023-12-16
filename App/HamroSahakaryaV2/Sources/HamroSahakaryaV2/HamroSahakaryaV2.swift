import SwiftUI

public protocol App: SwiftUI.App {
    
}

extension App {
    public var body: some Scene {
        WindowGroup {
            Text("Hello World SwiftUI")
        }
    }
}
