import Foundation

extension Optional {
  public var isEmpty: Bool {
    return self == nil
  }

  public var exists: Bool {
    return self != nil
  }
}
