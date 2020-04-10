//
//  SignedInViewModel.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/01/18.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct SignedInViewModel {
    
    private let viewSubject = BehaviorRelay<SignedInView>(value: .tabbar)
    var view: Observable<SignedInView> {
        return viewSubject.asObservable()
    }
    
}
