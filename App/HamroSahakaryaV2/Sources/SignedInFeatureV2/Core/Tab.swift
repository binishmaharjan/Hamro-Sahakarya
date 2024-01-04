import Foundation
import SwiftUI

public enum Tab: String {
    case home
    case logs
    case profile
    
    public static var items = [
        TabItem(icon: .init(systemName: "house.fill"), tab: .home),
        TabItem(icon: .init(systemName: "folder.fill"), tab: .logs),
        TabItem(icon: .init(systemName: "person.fill"), tab: .profile),
    ]
}

public struct TabItem: Identifiable {
    public var id = UUID()
    public var icon: Image
    public var tab: Tab
    
    public init(icon: Image, tab: Tab) {
        self.icon = icon
        self.tab = tab
    }
}
