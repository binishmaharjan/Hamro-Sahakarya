//
//  HomeContentView.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/05/04.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit

enum HomeContentView: Int {
    
    case memberGraph
    case accountDetail
    case notice
    
    var title: String {
        switch self {
        case .accountDetail:
            return "Account Detail"
        case .memberGraph:
            return "Member Graph"
        case .notice:
            return "Notice"
        }
    }
    
    var index: Int {
        switch self {
        case .accountDetail:
            return 1
        case .memberGraph:
            return 0
        case .notice:
            return 2
        }
    }
}
