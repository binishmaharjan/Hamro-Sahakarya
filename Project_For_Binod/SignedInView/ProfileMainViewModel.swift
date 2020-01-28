//
//  ProfileMainViewModel.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/01/28.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

typealias ProfileMainNavigationAction = NavigationAction<ProfileMainView>

protocol ProfileMainViewModel {
  var view: Observable<ProfileMainNavigationAction> { get }
  func navigate(to view: ProfileMainView)
  func uiPresented(profileView: ProfileMainView)
}

final class DefaultProfileMainViewModel: ProfileMainViewModel {
  
  private let _view = BehaviorSubject<ProfileMainNavigationAction>(value: .present(view: .profileView))
  var view: Observable<ProfileMainNavigationAction> { return _view.asObservable() }
}

extension DefaultProfileMainViewModel {
  func navigate(to view: ProfileMainView) {
    _view.onNext(.present(view: view))
  }
  
  func uiPresented(profileView: ProfileMainView) {
    _view.onNext(.presented(view: profileView))
  }
}
