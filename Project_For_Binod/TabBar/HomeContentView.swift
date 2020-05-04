//
//  HomeContentView.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/05/04.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation

enum HomeContentView {
    
    case accountDetail
    case memberGraph
    case monthlyDetail
    
    var title: String {
        switch self {
        case .accountDetail:
            return "Account Detail"
        case .memberGraph:
            return "Member Graph"
        case .monthlyDetail:
            return "Monthly Detail"
        }
    }
}
