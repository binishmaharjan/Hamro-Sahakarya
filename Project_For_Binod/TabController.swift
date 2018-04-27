//
//  TabController.swift
//  Project_For_Binod
//
//  Created by guest on 2018/02/02.
//  Copyright © 2018年 JEC. All rights reserved.
//

import UIKit

class TabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //Gray color for unselected item
        let color = UIColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 1)
        
        ////color of item in tabbar controller
        self.tabBar.tintColor = UIColor(hex: "3B252C")
        
        //color of background of tabBar controller
        self.tabBar.barTintColor = UIColor(hex: "8F6593")
        
        //disable tranlucent
        self.tabBar.isTranslucent = false
        
    
        
        //color of text Under icon
        //noraml state
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : color], for: .normal)
        //selected state
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.white], for: .selected)
        
        //Color of unselected  icon with extended UIiMage func
        self.tabBar.items?.forEach({ (item) in
            if let image = item.image{
                item.image = image.imageColor(color: color).withRenderingMode(.alwaysOriginal)
            }
        })
        

    }
}


