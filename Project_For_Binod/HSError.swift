//
//  RemoteApiError.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/11/09.
//  Copyright © 2019 JEC. All rights reserved.
//

import Foundation


enum HSError: Error {
  
  case loginError
  case signUpError
  case networkFailedError
  case dataDecodingError
  case dataEncodingError
  
  case saveDataError
  case readDataError
  case noSnapshotError
  case emptyDataError
  
}


struct RemoteApiErrorFactory {
  
}
