//
//  StoryboardInstantiable.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/01/01.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit

protocol StoryboardInstantiable {
  static var className: String { get }
  static func loadFromStoryboard() -> Self
}

extension StoryboardInstantiable {
  static var className: String {
    return String(describing: Self.self)
  }
  
  static func loadFromStoryboard() -> Self {
    let storyboard = UIStoryboard(name: className, bundle: nil)
    guard let viewController = storyboard.instantiateViewController(withIdentifier: className) as? Self else {
      fatalError("Couldnot instantiate ViewController: \(className)")
    }
    
    return viewController
  }
}
