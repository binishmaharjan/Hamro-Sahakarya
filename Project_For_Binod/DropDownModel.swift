//
//  DropDownModel.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/11/23.
//  Copyright © 2019 JEC. All rights reserved.
//

import Foundation

/// Data Model for the Drop Down Notitication
struct DropDownModel {
    let dropDownType: DropDownType
    let message: String
    
    static let defaultDropDown = DropDownModel(dropDownType: .normal, message: "Default Drop Down")
}
