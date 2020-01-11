//
//  ColorPalette.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/01/04.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit

protocol ColorPaletteProtocol {
  var onColorDidChange: ((_ color: UIColor) -> ())? { get }
  var elementSize: CGFloat { get }
}

/// Color Picker For Choosing a Color
class ColorPalette: UIView, ColorPaletteProtocol {
  
  var onColorDidChange: ((_ color: UIColor) -> ())?
  var elementSize: CGFloat = 1 {
    didSet { setNeedsDisplay() }
  }
  
  private let saturationExponentTop: Float = 2.0
  private let saturationExponentBottom: Float = 1.3
  
  private var mainPaletteRect: CGRect = .zero
  
  // MARK: Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }
  
  private func test(color: UIColor) {
    Dlog(color)
  }
  
  // MARK: LifeCycle
  override func draw(_ rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()
  
    mainPaletteRect = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
    
    // Main Palette
    for y in stride(from: CGFloat.zero, to: mainPaletteRect.height, by: elementSize) {
      
      var saturation = y < mainPaletteRect.height / 2.0 ? CGFloat(2 * y) / mainPaletteRect.height : 2.0 * CGFloat(mainPaletteRect.height - y) / mainPaletteRect.height
      saturation = CGFloat(powf(Float(saturation), y < mainPaletteRect.height / 2.0 ? saturationExponentTop : saturationExponentBottom))
      
      let brightness = y < mainPaletteRect.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(mainPaletteRect.height - y) / mainPaletteRect.height
      
      for x in stride(from: CGFloat.zero, to: mainPaletteRect.width, by: elementSize) {
        guard let context = context else { fatalError("No Context") }
        
        let hue = x / mainPaletteRect.width
        let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
        
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: x, y: y + mainPaletteRect.origin.y, width: elementSize, height: elementSize))
      }
    }
    
  }
  
  // MARK: Methods
  /// Initial setup for the color view
  private func setup() {
    clipsToBounds = true
    let touchGesture = UILongPressGestureRecognizer(target: self, action: #selector(touchedColor(gestureRecognizer:)))
    touchGesture.minimumPressDuration = 0
    touchGesture.allowableMovement = .greatestFiniteMagnitude
    addGestureRecognizer(touchGesture)
    onColorDidChange = test(color:)
  }
  
  @objc private func touchedColor(gestureRecognizer: UILongPressGestureRecognizer) {
    let point = gestureRecognizer.location(in: self)
    let color = getColorAtPoint(point: point)
    
    self.onColorDidChange?(color)
  }
  
  /// Get the uiColor at the point of user touch
  ///
  /// - Parameter point: location of the user touch
  /// - Return: uicolor at the location
  private func getColorAtPoint(point: CGPoint)  -> UIColor {
    var roundedPoint = CGPoint(x: elementSize * CGFloat(Int(point.x / elementSize)),
                               y: elementSize * CGFloat(Int(point.y / elementSize)))
    
    let hue = roundedPoint.x / bounds.width
    
    // Main Palette
    if mainPaletteRect.contains(point) {
       // Offset point. because mainPalette.origin.y is not 0
      roundedPoint.y -= mainPaletteRect.origin.y
      
      var saturation = roundedPoint.y < mainPaletteRect.height / 2.0 ? CGFloat(2 * roundedPoint.y) / mainPaletteRect.height
        : 2.0 * CGFloat(mainPaletteRect.height - roundedPoint.y) / mainPaletteRect.height
      
      saturation =  CGFloat(powf(Float(saturation), roundedPoint.y < mainPaletteRect.height / 2.0 ? saturationExponentTop : saturationExponentBottom))
      let brightness = roundedPoint.y > mainPaletteRect.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(mainPaletteRect.height - roundedPoint.y) / mainPaletteRect.height
      
      return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
      
    } else {
      return UIColor(white: hue, alpha: 1.0)
    }
  }  
  
}

