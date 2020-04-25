//
//  HomeViewModel.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/04/25.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol HomeViewModelProtocol {
    
}

struct HomeViewModel: HomeViewModelProtocol {
    
    private let homeViewResponder: HomeViewResponder
    private let userSessionRepository: UserSessionRepository
    
    init(homeViewResponder: HomeViewResponder, userSessionRepository: UserSessionRepository) {
        self.homeViewResponder = homeViewResponder
        self.userSessionRepository = userSessionRepository
    }
}
