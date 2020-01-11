//
//  ColorPaletteViewModel.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/01/04.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum ColorPaletteEvent {
  case selectButtonTapped
  case cancelButtonTapped
}

protocol ColorPaletteViewModelProtocol {
  var selectedColorInput: BehaviorRelay<UIColor> { get }
  var event: Observable<ColorPaletteEvent> { get }
  var selectButtonTapped: Binder<Void> { get }
  var cancelButtonTapped: Binder<Void> { get }
}

class ColorPaletteViewModel: ColorPaletteViewModelProtocol {
  var selectedColorInput = BehaviorRelay<UIColor>(value: .mainOrange)
  
  private let eventSubject = PublishSubject<ColorPaletteEvent>()
  var event: Observable<ColorPaletteEvent> {
    return eventSubject.asObservable()
  }
  
  var selectButtonTapped: Binder<Void> {
    return Binder(eventSubject) { observer, _ in
      observer.onNext(.selectButtonTapped)
    }
  }
  
  var cancelButtonTapped: Binder<Void> {
    return Binder(eventSubject) { observer, _ in
      observer.onNext(.cancelButtonTapped)
    }
  }
  
}
