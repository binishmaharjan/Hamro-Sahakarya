import Foundation

public extension Bundle {
    /// Bundle For sharedUIs module to access resources from different modules
    static var sharedUIs: Bundle { .module }
}

// MARK: App Details
public extension Bundle {
    static var appVersion: String {
        guard let version = Self.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
            return "vX.X.X"
        }
        return "v\(version)"
    }

    static var appName: String {
        guard let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String else {
            return ""
        }
        return appName
    }
}
