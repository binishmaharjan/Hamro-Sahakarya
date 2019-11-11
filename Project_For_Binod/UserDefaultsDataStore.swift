//
//  UserDefaultsDataStore.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/11/09.
//  Copyright © 2019 JEC. All rights reserved.
//

import Foundation
import PromiseKit

class UserDefaultsDataStore: UserDataStore {

  private let userProfileCoder: UserProfileCoding
  private let userProfileKey = "UserProfileKey"
  
  init(userProfileCoder: UserProfileCoding) {
    self.userProfileCoder = userProfileCoder
  }
  
  func readUserProfile() -> Promise<UserProfile?> {
    return Promise<UserProfile?> { [weak self] seal in
        
        guard let self = self else {
          seal.fulfill(nil)
          return
        }
        
        guard let data = UserDefaults.standard.value(forKey: self.userProfileKey) as? Data else {
          seal.fulfill(nil)
          return
        }
      
      let userProfile = userProfileCoder.decode(data: data)
      seal.fulfill(userProfile)
      
    }
  }
  
  func save(userProfile: UserProfile) -> Promise<UserProfile> {
    
    return Promise<UserProfile> { seal in
      
      let encodedData = userProfileCoder.encode(userProfile: userProfile)
      UserDefaults.standard.set(encodedData, forKey: userProfileKey)
      seal.fulfill(userProfile)
    }

  }

  func delete(userProfile: UserProfile) -> Promise<UserProfile> {

    return Promise<UserProfile> { seal in
      UserDefaults.standard.set(Data(), forKey: userProfileKey)
      seal.fulfill(userProfile)
    }
  }
}

