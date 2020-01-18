//
//  ReactiveProperty.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/01/18.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

@propertyWrapper
class ReadOnlyReactiveProperty<Element> {
  private let relay: BehaviorRelay<Element>
  
  var wrappedValue: Element { relay.value }
  
  var projectedValue: Observable<Element> { relay.asObservable() }
  
  init(wrappedValue: Element) {
    self.relay = BehaviorRelay(value: wrappedValue)
  }
  
  func onNext(value: Element) {
    self.relay.accept(value)
  }
}

@propertyWrapper
class ReactiveProperty<Element> {
  private let relay: BehaviorRelay<Element>
  
  var wrappedValue: Element { didSet { relay.accept(wrappedValue) } }
  
  var projectValue: Observable<Element> { relay.asObservable() }
  
  init(wrappedValue: Element) {
    self.relay = BehaviorRelay(value: wrappedValue)
    self.wrappedValue = wrappedValue
  }
}
