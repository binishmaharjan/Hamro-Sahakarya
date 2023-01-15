import Foundation

public enum State {
    case idle
    case completed
    case error(Error)
    case loading
}
