import Foundation
import SwiftUI
import SharedUIs

public enum Tab {
    case home
    case logs
    case profile
    
    public var title: String {
        switch self {
        case .home: return #localized("Home")
        case .logs: return #localized("Logs")
        case .profile: return #localized("Profile")
        }
    }
    
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
