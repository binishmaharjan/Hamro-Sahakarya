import Foundation

public enum AppError {
    
    public enum UserDefaults: LocalizedError {
        case decode
        case encode
        
        public var errorDescription: String {
            switch self {
            case .decode: return "UserDefaults: Failed to decode."
            case .encode: return "UserDefaults: Failed to encode."
            }
        }
    }
}
