//
//  AddOrDeductAmountViewModel.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/05/17.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation

protocol AddOrDeductAmountViewModelProtocol {
    
}

struct AddOrDeductAmountViewModel: AddOrDeductAmountViewModelProtocol {
    private let userSessionRepository: UserSessionRepository
    private let userSession: UserSession
    
    init(userSessionRepository: UserSessionRepository, userSession: UserSession) {
        self.userSessionRepository = userSessionRepository
        self.userSession = userSession
    }
}
