import Foundation
import RxSwift
import RxCocoa

@propertyWrapper
public class InternallyMutableProperty<Element> {
    private let relay: BehaviorRelay<Element>

    public var wrappedValue: Element {
        relay.value
    }

    public var projectedValue: Observable<Element> {
        relay.asObservable()
    }

    public init(wrappedValue: Element) {
        self.relay = BehaviorRelay(value: wrappedValue)
    }

    public func onNext(value: Element) {
        self.relay.accept(value)
    }
}

@propertyWrapper
public class ReactiveProperty<Element> {
    private let relay: BehaviorRelay<Element>

    public var wrappedValue: Element {
        didSet {
            relay.accept(wrappedValue)
        }
    }

    var projectValue: Observable<Element> {
        relay.asObservable()
    }

    public init(wrappedValue: Element) {
        self.relay = BehaviorRelay(value: wrappedValue)
        self.wrappedValue = wrappedValue
    }
}

/*
 Property Wrapper
 Publish Subject Wrapped as  Observable
 */
@propertyWrapper
public class PropertyPublishSubject<Element> {
    let publishSubject =  PublishSubject<Element>()

    public var wrappedValue: Observable<Element> {
        return publishSubject.asObservable()
    }

    public init(value: Element) {
        self.publishSubject.onNext(value)
    }

    public init() {

    }

    public func onNext(_ value: Element) {
        publishSubject.onNext(value)
    }
}

/*
 Property Wrapper
 Behaviour Relay Wrapped as  Driver
 */
@propertyWrapper
public class PropertyBehaviorRelay<Element> {
    let behaviorRelay: BehaviorRelay<Element>

    public var wrappedValue: Driver<Element> {
        return behaviorRelay.asDriver()
    }

    var value: Element {
        return behaviorRelay.value
    }

    public init(value: Element) {
        self.behaviorRelay = BehaviorRelay(value: value)
    }

    public func accept(_ value: Element) {
        behaviorRelay.accept(value)
    }
}
