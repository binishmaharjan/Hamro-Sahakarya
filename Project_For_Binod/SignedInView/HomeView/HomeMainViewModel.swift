//
//  HomeMainViewModel.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/04/25.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

typealias HomeNavigationAction = NavigationAction<HomeView>

enum HomeView {
    case home
}
protocol HomeViewResponder {
    var view: Observable<HomeNavigationAction> { get }
}

protocol HomeMainViewModelProtocol: HomeViewResponder {
    func navigate(to view: HomeView)
    func uiPresented(homeView: HomeView)
}

struct HomeMainViewModel: HomeMainViewModelProtocol {
    private let _view = BehaviorSubject<HomeNavigationAction>(value: .present(view: .home))
    var view: Observable<HomeNavigationAction> {
        return _view.asObservable()
    }
    
    func navigate(to view: HomeView) {
        _view.onNext(.present(view: view))
    }
    
    func uiPresented(homeView: HomeView) {
        _view.onNext(.presented(view: homeView))
    }
    
}

