//
//  NSMutableData_Extension.swift
//  Project_For_Binod
//
//  Created by guest on 2018/02/03.
//  Copyright © 2018年 JEC. All rights reserved.
//

import UIKit


//Extension For NSMutableData For Creating the body for the request for php file with the data of photo
extension NSMutableData{
    func appendString(string : String){
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
    
}
