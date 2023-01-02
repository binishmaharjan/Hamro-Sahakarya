import Foundation
import RxCocoa
import RxSwift
import UIKit

public enum ColorPaletteEvent {
    case selectButtonTapped
    case cancelButtonTapped
}

public protocol ColorPaletteViewModelProtocol {
    var selectedColorInput: BehaviorRelay<UIColor> { get }
    var event: Observable<ColorPaletteEvent> { get }
    var selectButtonTapped: Binder<Void> { get }
    var cancelButtonTapped: Binder<Void> { get }
}

public final class ColorPaletteViewModel: ColorPaletteViewModelProtocol {
    public var selectedColorInput = BehaviorRelay<UIColor>(value: .mainOrange)
    
    private let eventSubject = PublishSubject<ColorPaletteEvent>()
    public var event: Observable<ColorPaletteEvent> {
        return eventSubject.asObservable()
    }
    
    public var selectButtonTapped: Binder<Void> {
        return Binder(eventSubject) { observer, _ in
            observer.onNext(.selectButtonTapped)
        }
    }
    
    public var cancelButtonTapped: Binder<Void> {
        return Binder(eventSubject) { observer, _ in
            observer.onNext(.cancelButtonTapped)
        }
    }

    public init() {}
}
