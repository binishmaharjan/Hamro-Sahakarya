//
//  NoticeViewModel.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/05/24.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation
import RxSwift

protocol NoticeViewModelProtocol {
    var message: Observable<String> { get }
    var admin: Observable<String> { get }
}

struct NoticeViewModel: NoticeViewModelProtocol {
    var message: Observable<String>
    var admin: Observable<String>
    
    init(message:Observable<String>, admin: Observable<String>) {
        self.message = message
        self.admin = admin
    }
    
}
