//
//  ProfileTopViewModel.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/02/01.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation
import RxCocoa

protocol ProfileTopCellViewModel {
    var imageUrl: Driver<URL?> { get }
    var fullname: Driver<String> { get }
    var status: Driver<String> { get }
}

struct DefaultProfileTopCellViewModel: ProfileTopCellViewModel {
    private let userSession: UserSession
    
    var imageUrl: Driver<URL?> {
        return userSession.profile
            .map { $0.iconUrl }
            .map { URL(string: $0 ?? "") }
            .asDriver()
    }
    
    var fullname: Driver<String> {
        return userSession.profile
            .map { $0.username }
            .asDriver()
    }
    
    var status: Driver<String> {
        return userSession.profile
            .map { $0.status.rawValue }
            .asDriver()
    }
    
    init(userSession: UserSession) {
        self.userSession = userSession
    }
    
}
