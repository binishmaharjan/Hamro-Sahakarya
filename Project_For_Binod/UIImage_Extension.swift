//
//  UIImage_Extension.swift
//  Project_For_Binod
//
//  Created by guest on 2018/02/03.
//  Copyright © 2018年 JEC. All rights reserved.
//

import UIKit


//Extension of UIimage to created colorful tab icon (unselecged ones)
extension UIImage{
    func imageColor(color : UIColor)-> UIImage{
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext()! as CGContext
        
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        
        context.clip(to: rect, mask: self.cgImage!)
        
        color.setFill()
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

