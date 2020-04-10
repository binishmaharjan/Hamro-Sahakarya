//
//  State.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/01/29.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation

enum State {
    case idle
    case completed
    case error(Error)
    case loading
}
