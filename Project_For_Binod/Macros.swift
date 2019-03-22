//
//  Macros.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/03/22.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit

#if DEBUG
let IS_DEBUG = true
#else
let IS_DEBUG = false
#endif

//Log for Debug
func Dlog(_ obj: Any? = nil, file:String = #file, function:String = #function, line: Int = #line){
  #if DEBUG
  var filename:NSString = file as NSString
  filename = filename.lastPathComponent as NSString
  if let obj = obj{
    print("[File:\(filename) Func:\(function) Line:\(line)] : \(obj)")
  }else{
    print("[File:\(filename) Func:\(function) Line:\(line)]")
  }
  #endif
}

//Log for Release
func Alog(_ obj: Any? = nil, file: String = #file, function: String = #function, line: Int = #line){
  var filename: NSString = file as NSString
  filename = filename.lastPathComponent as NSString
  if let obj = obj{
    NSLog("[File:\(filename) Func:\(function) Line:\(line)] : \(obj)")
  }else{
    NSLog("[File:\(filename) Func:\(function) Line:\(line)]")
  }
}

//Localize Text
func LOCALIZE(_ text: String) -> String{
  return NSLocalizedString(text, comment: "")
}

//Generate Random Number
func randomID(length: Int) -> String {
  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  return String((0...length-1).map{ _ in letters.randomElement()! })
}


let appDelegate = UIApplication.shared.delegate as! AppDelegate


func getRangeOfSubString(subString: String, fromString: String) -> NSRange {
  let sampleLinkRange = fromString.range(of: subString)!
  let startPos = fromString.distance(from: fromString.startIndex, to: sampleLinkRange.lowerBound)
  let endPos = fromString.distance(from: fromString.startIndex, to: sampleLinkRange.upperBound)
  let linkRange = NSMakeRange(startPos, endPos - startPos)
  return linkRange
}

extension NSMutableAttributedString {
  
  func setColorForText(textForAttribute: String, withColor color: UIColor) {
    let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
    
    self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
  }
  
}
