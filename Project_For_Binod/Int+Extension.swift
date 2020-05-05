//
//  Int+Extension.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/05/03.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation

extension Int {
    var currency: String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale(identifier: "ja_JP")
        return currencyFormatter.string(for: self) ?? "¥0"
    }
}
