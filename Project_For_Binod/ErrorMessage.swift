//
//  ErrorMessage.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/10/19.
//  Copyright © 2019 JEC. All rights reserved.
//

import Foundation

struct ErrorMessage: Error {
  
  // MARK: Properties
  let id: UUID
  let title: String
  let message: String
  
  init(title: String, message: String) {
    self.id = UUID()
    self.title = title
    self.message = message
  }
}


extension ErrorMessage: Equatable {
  
  static func ==(lhs: ErrorMessage, rhs: ErrorMessage) -> Bool {
    return lhs.id == rhs.id
  }
}
