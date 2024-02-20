import Foundation

extension Optional {
  public var isEmpty: Bool {
    return self == nil
  }

  public var exists: Bool {
    return self != nil
  }
}

extension Optional where Wrapped == Int {
    public var safeUnwrap: Int {
        guard let unWrapped = self else { return 0 }
        return unWrapped
    }
}

extension Optional where Wrapped == String {
    public var safeUnwrap: String {
        guard let unWrapped = self else { return "" }
        return unWrapped
    }
}
