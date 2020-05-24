//
//  Notice.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/05/24.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation

struct Notice: Codable {
    let message: String
    let admin: String
    let dateCreated: String
    
    private enum CodingKeys: String, CodingKey {
        case message
        case admin
        case dateCreated = "date_created"
    }
    
    static var blankNotice = Notice(message: "", admin: "", dateCreated: "")
}
