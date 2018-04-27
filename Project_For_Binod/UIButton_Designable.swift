//
//  UIButton_Designable.swift
//  Project_For_Binod
//
//  Created by guest on 2017/12/26.
//  Copyright © 2017年 JEC. All rights reserved.
//

import UIKit

@IBDesignable
class UIButton_Designable: UIButton {

    //For corner radius
    @IBInspectable var CornerRadius : CGFloat = 0 {
        didSet{
            self.layer.cornerRadius = CornerRadius
        }
    }
    
    //For Border Color
    @IBInspectable var BorderColor : UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = BorderColor.cgColor
        }
    }
    
    //For BorderWidth
    @IBInspectable var BorderWidth : CGFloat = 0{
        didSet{
            self.layer.borderWidth = BorderWidth
        }
    }
    
    //For Background
    @IBInspectable var Background : UIColor = UIColor.clear {
        didSet{
            self.layer.backgroundColor = Background.cgColor
        }
    }
    
    //For Clips Bounds
    @IBInspectable var ClipBounds : Bool =   false{
        didSet{
            self.clipsToBounds = ClipBounds
        }
    }
    
    //For the first color of the gradient
    @IBInspectable var FirstColor : UIColor = UIColor.clear{
        didSet{
            updateView()
        }
    }
    
    //For the second color of the gradient
    @IBInspectable var secondColor : UIColor = UIColor.clear{
        didSet{
            updateView()
        }
    }
    
     //Creating the new layer for the the gradient
    override class var layerClass : AnyClass {
        get{
            return CAGradientLayer.self
        }
    }
    
     //Update the gradient view
    func updateView(){
        let layer = self.layer as! CAGradientLayer
        layer.startPoint  = CGPoint(x: 1.0, y: 1.0)
        layer.endPoint = CGPoint(x: 0.0, y: 0.0)
        layer.colors = [FirstColor.cgColor,secondColor.cgColor]
    }
    

}
