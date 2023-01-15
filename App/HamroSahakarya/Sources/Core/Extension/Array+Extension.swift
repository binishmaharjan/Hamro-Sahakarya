import Foundation

extension Array {

  /*
   安全な配列アクセスを提供する
   indexが範囲外の時、setterは無視し、getterはnilをか返す
   */
  public subscript(optional index: Int) -> Element? {
    get {
      guard self.indices ~= index else {
        return nil
      }
      return self[index]
    }

    set {
      guard self.indices ~= index else {
        DebugLog("WARN: index(\(index)) is out of range, so ignored. (array: \(self)")
        return
      }

      guard let newValue = newValue else {
          DebugLog("WARN: new Value must not be nil value, so ignored. (array: \(self)")
        return
      }

      self[index] = newValue
    }
  }

  /*
   重複を取り除いた配列に変換する
   内部でNSOrderedSetを使うので元の配列の順序になることが保証される
   */
  public func unique() -> [Element] {
    let orderSet = NSOrderedSet(array: self)
    return orderSet.array.compactMap { $0 as? Element }
  }
}
