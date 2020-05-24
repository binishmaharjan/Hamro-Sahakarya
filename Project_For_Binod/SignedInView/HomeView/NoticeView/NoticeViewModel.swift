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
    var dateCreated: Observable<String> { get }
}

struct NoticeViewModel: NoticeViewModelProtocol {
    let message: Observable<String>
    let admin: Observable<String>
    let dateCreated: Observable<String>
    
    init(notice: Observable<Notice>) {
        self.message = notice.map { $0.message }
        self.admin = notice.map { "From: \($0.admin)" }
        self.dateCreated = notice.map { $0.dateCreated.toDateAndTime.toGegorianMonthDateYearString }
    }
    
}
