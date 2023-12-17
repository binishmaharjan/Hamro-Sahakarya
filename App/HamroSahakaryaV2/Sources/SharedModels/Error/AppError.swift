import Foundation
import SharedUIs

public enum AppError {
    
    public enum UserDefaults: LocalizedError {
        case decode
        case encode
        
        public var errorDescription: String {
            switch self {
            case .decode: return #localized("UserDefaults: Failed to decode.")
            case .encode: return #localized("UserDefaults: Failed to encode.")
            }
        }
    }
}
