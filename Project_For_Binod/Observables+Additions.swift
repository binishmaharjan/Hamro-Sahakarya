//
//  Observables+Additions.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/03/29.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
extension Observable {
  /**
   Observable.create { observer in ... }
   メソッドを使う時によく return Disposables.create() と書くことが多いので
   その処理をラップする
   */
  static func create<O>(_ handler: @escaping (AnyObserver<O>) -> Void) -> Observable<O> {
    return Observable<O>.create { (observer: AnyObserver<O>) -> Disposable in
      handler(observer)
      return Disposables.create()
    }
  }
  /**
   上記メソッドの flatMapLatest バージョン
   */
  public func flatMapLatest<O>(_ handler: @escaping (Element, AnyObserver<O>) -> Void) -> Observable<O> {
    return self.flatMapLatest { (element: Element) -> Observable<O> in
      return Observable<O>.create { (observer: AnyObserver<O>) -> Disposable in
        handler(element, observer)
        return Disposables.create()
      }
    }
  }
}
// MARK: - Bool
public extension Observable where Element == Bool {
  func filterTrue() -> Observable<Element> {
    return filter { $0 }
  }
  func filterFalse() -> Observable<Element> {
    return filter { $0 == false }
  }
}
// MARK: - Equatable
public extension ObservableType where Element: Equatable {
  func filter(_ value: Element) -> Observable<Element> {
    return filter { element in
      element == value
    }
  }
}
// MARK: - Optional
public protocol OptionalType {
  associatedtype Wrapped
  func flatMap<U>(_ transform: (Wrapped) throws -> U?) rethrows -> U? // Optional で定義されているメソッドを書いているだけ
}
extension Optional: OptionalType {}
public extension ObserverType where Element == Swift.Void {
  func onNext() {
    onNext(Swift.Void())
  }
}
public extension ObservableType {
  /// flatMap でクロージャーを処理後、nil 以外ならアンラップして流す
  func skipNil<R>(_ transform: @escaping (Element) -> R) -> Observable<R.Wrapped> where R: OptionalType {
    return flatMap { element -> Observable<R.Wrapped> in
      transform(element).flatMap(Observable.just) ?? Observable.empty()
    }
  }
}
public extension ObservableType where Element: OptionalType {
  /// Optional の中身が nil 以外ならアンラップして流す
  func skipNil() -> Observable<Element.Wrapped> {
    return skipNil { $0 }
  }
  /// Optional の中身が nil 以外ならアンラップして流す。nil なら引数で指定した値を流す
  func unwrapOr(_ alternativeValue: Element.Wrapped) -> Observable<Element.Wrapped> {
    return flatMap { element -> Observable<Element.Wrapped> in
      let value = element.flatMap({ $0 }) ?? alternativeValue
      return Observable<Element.Wrapped>.just(value)
    }
  }
}
/// デフォルトイニシャライザーを持つことを保証するプロトコル
public protocol DefaultInitializerable {
  init()
  static func emptyValue() -> Self
}
public extension DefaultInitializerable {
  static func emptyValue() -> Self {
    return Self.init()
  }
}
extension Swift.String: DefaultInitializerable {} // String は適合している
extension Swift.Array: DefaultInitializerable {}
extension Swift.Dictionary: DefaultInitializerable {}
extension Swift.Int: DefaultInitializerable {}
extension CGRect: DefaultInitializerable {}
extension CGPoint: DefaultInitializerable {}
extension CGSize: DefaultInitializerable {}
public extension ObservableType where Element: OptionalType, Element.Wrapped: DefaultInitializerable {
  /// Optional の中身が nil 以外ならアンラップして流す。nil なら .init() の結果を返す
  func unwrapOrEmpty() -> Observable<Element.Wrapped> {
    return unwrapOr(Element.Wrapped.emptyValue())
  }
}
// MARK: - 変換
public extension Observable {
  // Observable の Element を Void に変換する
  func toVoid() -> Observable<Swift.Void> {
    return map { _ in Swift.Void() }
  }
  // Void 型の Driver に変換する
  func toVoidDriver() -> Driver<Swift.Void> {
    return toVoid().asDriver()
  }
  // エラーを無視する Driver に変換する
  func asDriver() -> Driver<Element> {
    return asDriver(onErrorDriveWith: Driver.empty())
  }
}
public extension Observable {
  func map<T>(to value: T) -> Observable<T> {
    return map { _ in value }
  }
  func mapDriver<R>(_ transform: @escaping (Element) -> R) -> Driver<R> {
    return map(transform).asDriver()
  }
}
// デバッグログ出力切り替え
public extension ObservableType {
  /// testmode = On のとき、ログを出す。それ以外はそのまま次の処理へ流す
  func trace(_ identifier: String? = nil, trimOutput: Bool = false, file: String = #file, line: UInt = #line, function: String = #function)
    -> Observable<Element> {
      #if DEBUG
        return self.debug(identifier, trimOutput: trimOutput, file: file, line: line, function: function)
     #else
        // 何もせず次の処理へ流す
        return self.map { $0 }
       #endif
  }
}
extension SharedSequenceConvertibleType {
  /// testmode = On のとき、ログを出す。それ以外はそのまま次の処理へ流す
  func trace(_ identifier: String? = nil, trimOutput: Bool = false, file: String = #file, line: UInt = #line, function: String = #function) -> RxCocoa.SharedSequence<Self.SharingStrategy, Self.Element> {
    #if DEBUG
      return debug(identifier, trimOutput: trimOutput, file: file, line: line, function: function)
    #else
      // 何もせず次の処理へ流す
      return map { $0 }
    #endif
  }
}
extension PrimitiveSequence {
  /// testmode = On のとき、ログを出す。それ以外はそのまま次の処理へ流す
  func trace(_ identifier: String? = nil, trimOutput: Bool = false, file: String = #file, line: UInt = #line, function: String = #function) -> RxSwift.PrimitiveSequence<Trait, Element> {
    #if DEBUG
      return debug(identifier, trimOutput: trimOutput, file: file, line: line, function: function)
    #else
      // 何もせず次の処理へ流す
      return self
    #endif
  }
}
// MARK: - Utilities
public extension ObservableType {
  /// Action to invoke for each element in the observable sequence.
  func subscribeNext(_ onNext: @escaping (Self.Element) -> Void) -> Disposable {
    return subscribe(onNext: onNext)
  }
  /// Action to invoke for each element in the observable sequence.
  func doNext(_ onNext: @escaping (Self.Element) throws -> Void) -> RxSwift.Observable<Self.Element> {
    return `do`(onNext: onNext)
  }
  /// Action to invoke before subscribing to source observable sequence.
  func doSubscribe(_ onSubscribe: @escaping () -> Void) -> RxSwift.Observable<Self.Element> {
    return `do`(onSubscribe: onSubscribe)
  }
  /// Action to invoke after subscribing to source observable sequence.
  func doSubscribed(_ onSubscribed: @escaping () -> Void) -> RxSwift.Observable<Self.Element> {
    return `do`(onSubscribed: onSubscribed)
  }
}
public extension SharedSequenceConvertibleType where Self.SharingStrategy == RxCocoa.DriverSharingStrategy {
  /// Action to invoke for each element in the observable sequence.
  func driveNext(_ onNext: @escaping (Self.Element) -> Void) -> Disposable {
    return drive(onNext: onNext)
  }
}
public extension ObservableType where Self.Element == Swift.Void {
  func catchErrorJustReturnVoid() -> RxSwift.Observable<Self.Element> {
    return catchErrorJustReturn( () )
  }
}
