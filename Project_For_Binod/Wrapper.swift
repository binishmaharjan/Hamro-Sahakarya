//
//  Wrapper.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/04/13.
//  Copyright © 2019 JEC. All rights reserved.
//

import Foundation


class Wrapper<T>:NSObject{
  
  let value : T
  
  init(_struct:T) {
    self.value = _struct
  }
  
  init(_bool:T){
    self.value = _bool
  }
}
