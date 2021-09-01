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
class InternallyMutableProperty<Element> {
    private let relay: BehaviorRelay<Element>
    
    var wrappedValue: Element {
        relay.value
    }
    
    var projectedValue: Observable<Element> {
        relay.asObservable()
    }
    
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
    
    var wrappedValue: Element {
        didSet {
            relay.accept(wrappedValue)
        }
    }
    
    var projectValue: Observable<Element> {
        relay.asObservable()
    }
    
    init(wrappedValue: Element) {
        self.relay = BehaviorRelay(value: wrappedValue)
        self.wrappedValue = wrappedValue
    }
}

/*
 Property Wrapper
 Publish Subject Wrapped as  Observable
 */
@propertyWrapper
class PropertyPublishSubject<Element> {
    let publishSubject =  PublishSubject<Element>()
    
    var wrappedValue: Observable<Element> {
        return publishSubject.asObservable()
    }
    
    init(value: Element) {
        self.publishSubject.onNext(value)
    }
    
    init() {
        
    }
    
    func onNext(_ value: Element) {
        publishSubject.onNext(value)
    }
}

/*
 Property Wrapper
 Behaviour Relay Wrapped as  Driver
 */
@propertyWrapper
class PropertyBehaviourRelay<Element> {
    let behaviourRelay: BehaviorRelay<Element>
    
    var wrappedValue: Driver<Element> {
        return behaviourRelay.asDriver()
    }
    
    var value: Element {
        return behaviourRelay.value
    }
    
    init(value: Element) {
        self.behaviourRelay = BehaviorRelay(value: value)
    }
    
    func accept(_ value: Element) {
        behaviourRelay.accept(value)
    }
}
